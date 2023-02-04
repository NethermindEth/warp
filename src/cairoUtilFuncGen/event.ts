import {
  DataLocation,
  EmitStatement,
  EventDefinition,
  FunctionCall,
  generalizeType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import {
  AbiEncode,
  AST,
  CairoType,
  createCairoFunctionStub,
  createCallToFunction,
  isValueType,
  IndexEncode,
  safeGetNodeType,
  TypeConversionContext,
  typeNameFromTypeNode,
  warpEventSignatureHash256FromString,
  EMIT_PREFIX,
} from '../export';
import { StringIndexedFuncGen } from './base';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';

export const BYTES_IN_FELT_PACKING = 31;
const BIG_ENDIAN = 1; // 0 for little endian, used for packing of bytes (31 byte felts -> a 248 bit felt)

const IMPLICITS =
  '{syscall_ptr: felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*, keccak_ptr: felt*}';

/**
 * Generates a cairo function that emits an event through a cairo syscall.
 * Then replace the emit statement with a call to the generated function.
 */
export class EventFunction extends StringIndexedFuncGen {
  private abiEncode: AbiEncode;
  private indexEncode: IndexEncode;

  constructor(abiEncode: AbiEncode, indexEcnode: IndexEncode, ast: AST, sourceUint: SourceUnit) {
    super(ast, sourceUint);
    this.abiEncode = abiEncode;
    this.indexEncode = indexEcnode;
  }

  public gen(node: EmitStatement, refEventDef: EventDefinition): FunctionCall {
    const argsTypes: TypeNode[] = node.vEventCall.vArguments.map(
      (arg) => generalizeType(safeGetNodeType(arg, this.ast.inference))[0],
    );

    const funcName = this.getOrCreate(refEventDef);

    const functionStub = createCairoFunctionStub(
      funcName,
      argsTypes.map((argT, index) =>
        isValueType(argT)
          ? [`param${index}`, typeNameFromTypeNode(argT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(argT, this.ast), DataLocation.Memory],
      ),
      [],
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory', 'keccak_ptr'],
      this.ast,
      this.sourceUnit,
    );

    return createCallToFunction(functionStub, node.vEventCall.vArguments, this.ast);
  }

  private getOrCreate(node: EventDefinition): string {
    // Add the canonicalSignatureHash so that generated function names don't collide when overloaded
    const key = `${node.name}_${this.ast.inference.signatureHash(node, ABIEncoderVersion.V2)}`;
    const existing = this.generatedFunctions.get(key);

    if (existing !== undefined) {
      return existing.name;
    }

    const [params, keysInsertions, dataInsertions] = node.vParameters.vParameters.reduce(
      ([params, keysInsertions, dataInsertions], param, index) => {
        const paramType = generalizeType(safeGetNodeType(param, this.ast.inference))[0];
        const cairoType = CairoType.fromSol(paramType, this.ast, TypeConversionContext.Ref);

        params.push({ name: `param${index}`, type: cairoType.toString() });

        if (param.indexed) {
          // An indexed parameter should go to the keys array
          if (isValueType(paramType)) {
            // If the parameter is a value type, we can just add it to the keys array
            // as it is, as we do regular abi encoding
            keysInsertions.push(
              this.generateSimpleEncodingCode(paramType, 'keys', `param${index}`),
            );
          } else {
            // If the parameter is a reference type, we hash the with special encoding
            // function: more at:
            //   https://docs.soliditylang.org/en/v0.8.14/abi-spec.html#encoding-of-indexed-event-parameters
            keysInsertions.push(
              this.generateComplexEncodingCode(paramType, 'keys', `param${index}`),
            );
          }
        } else {
          // A non-indexed parameter should go to the data array
          dataInsertions.push(this.generateSimpleEncodingCode(paramType, 'data', `param${index}`));
        }

        return [params, keysInsertions, dataInsertions];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>(), new Array<string>()],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');

    const topic: { low: string; high: string } = warpEventSignatureHash256FromString(
      this.ast.inference.signature(node, ABIEncoderVersion.V2),
    );

    const code = [
      `func ${EMIT_PREFIX}${key}${IMPLICITS}(${cairoParams}){`,
      `   alloc_locals;`,
      `   // keys arrays`,
      `   let keys_len: felt = 0;`,
      `   let (keys: felt*) = alloc();`,
      `   //Insert topic`,
      this.generateAnonymizeCode(
        node.anonymous,
        topic,
        this.ast.inference.signature(node, ABIEncoderVersion.V2),
      ),
      ...keysInsertions,
      `   // keys: pack 31 byte felts into a single 248 bit felt`,
      `   let (keys_len: felt, keys: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, keys_len, keys);`,
      `   // data arrays`,
      `   let data_len: felt = 0;`,
      `   let (data: felt*) = alloc();`,
      ...dataInsertions,
      `   // data: pack 31 bytes felts into a single 248 bits felt`,
      `   let (data_len: felt, data: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, data_len, data);`,
      `   emit_event(keys_len, keys, data_len, data);`,
      `   return ();`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.starknet.common.syscalls', 'emit_event');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('warplib.keccak', 'pack_bytes_felt');
    this.requireImport('starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin');

    this.generatedFunctions.set(key, { name: `${EMIT_PREFIX}${key}`, code: code });
    return `${EMIT_PREFIX}${key}`;
  }

  private generateAnonymizeCode(
    isAnonymous: boolean,
    topic: { low: string; high: string },
    eventSig: string,
  ): string {
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport(`warplib.maths.utils`, 'felt_to_uint256');
    this.requireImport('warplib.dynamic_arrays_util', 'fixed_bytes256_to_felt_dynamic_array_spl');
    if (isAnonymous) {
      return [`// Event is anonymous, topic won't be added to keys`].join('\n');
    }
    return [
      `    let topic256: Uint256 = Uint256(${topic.low}, ${topic.high});// keccak of event signature: ${eventSig}`,
      `    let (keys_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(keys_len, keys, 0, topic256);`,
    ].join('\n');
  }

  private generateSimpleEncodingCode(type: TypeNode, arrayName: string, argName: string): string {
    const abiFunc = this.abiEncode.getOrCreate([type]);

    this.requireImport('warplib.memory', 'wm_to_felt_array');
    this.requireImport('warplib.keccak', 'felt_array_concat');

    return [
      `   let (mem_encode: felt) = ${abiFunc}(${argName});`,
      `   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);`,
      `   let (${arrayName}_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, ${arrayName}_len, ${arrayName});`,
    ].join('\n');
  }

  private generateComplexEncodingCode(type: TypeNode, arrayName: string, argName: string): string {
    const abiFunc = this.indexEncode.getOrCreate([type]);

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport(`warplib.maths.utils`, 'felt_to_uint256');
    this.requireImport('warplib.keccak', 'warp_keccak');
    this.requireImport('warplib.dynamic_arrays_util', 'fixed_bytes256_to_felt_dynamic_array_spl');

    return [
      `   let (mem_encode: felt) = ${abiFunc}(${argName});`,
      `   let (keccak_hash256: Uint256) = warp_keccak(mem_encode);`,
      `   let (${arrayName}_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(${arrayName}_len, ${arrayName}, 0, keccak_hash256);`,
    ].join('\n');
  }
}
