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
  safeGetNodeType,
  TypeConversionContext,
  typeNameFromTypeNode,
} from '../export';
import { StringIndexedFuncGen } from './base';

import keccak from 'keccak';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';

export const MASK_250 = BigInt('0x3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
export const BYTES_IN_FELT_PACKING = 31;
const BIG_ENDIAN = 1; // 0 for little endian, used for packing of bytes (31 byte felts -> a 248 bit felt)

const IMPLICITS =
  '{syscall_ptr: felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * Generates a cairo function that emits an event through a cairo syscall.
 * Then replace the emit statement with a call to the generated function.
 */
export class EventFunction extends StringIndexedFuncGen {
  private abiEncode: AbiEncode;

  constructor(abiEncode: AbiEncode, ast: AST, sourceUint: SourceUnit) {
    super(ast, sourceUint);
    this.abiEncode = abiEncode;
  }

  public gen(node: EmitStatement, refEventDef: EventDefinition): FunctionCall {
    const argsTypes: TypeNode[] = node.vEventCall.vArguments.map(
      (arg) => generalizeType(safeGetNodeType(arg, this.ast.compilerVersion))[0],
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
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      this.sourceUnit,
    );

    return createCallToFunction(functionStub, node.vEventCall.vArguments, this.ast);
  }

  private getOrCreate(node: EventDefinition): string {
    const key = node.name;
    const existing = this.generatedFunctions.get(key);

    if (existing !== undefined) {
      return existing.name;
    }

    const [params, keysInsertions, dataInsertions] = node.vParameters.vParameters.reduce(
      ([params, keysInsertions, dataInsertions], param, index) => {
        const paramType = generalizeType(safeGetNodeType(param, this.ast.compilerVersion))[0];
        const cairoType = CairoType.fromSol(paramType, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });
        if (param.indexed) {
          keysInsertions.push(this.generateInsertionCode(paramType, 'keys_wt', `param${index}`));
        } else {
          dataInsertions.push(this.generateInsertionCode(paramType, 'data', `param${index}`));
        }
        return [params, keysInsertions, dataInsertions];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>(), new Array<string>()],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');

    const topic: BigInt =
      BigInt(
        `0x${keccak('keccak256')
          .update(node.canonicalSignature(ABIEncoderVersion.V2))
          .digest('hex')}`,
      ) & BigInt(MASK_250);

    const code = [
      `func _emit_${key}${IMPLICITS}(${cairoParams}){`,
      `   alloc_locals;`,
      `   // keys arrays`,
      `   let keys_wt_len: felt = 0;`,
      `   let (keys_wt: felt*) = alloc();`, // keys array without topic
      ...keysInsertions,
      `   let (keys_wt_len: felt, keys_wt: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, keys_wt_len, keys_wt);`,
      this.generateAnonymizeCode(
        node.anonymous,
        topic,
        node.canonicalSignature(ABIEncoderVersion.V2),
      ),
      `   // data arrays`,
      `   let data_len: felt = 0;`,
      `   let (data: felt*) = alloc();`,
      ...dataInsertions,
      `   let (data_len: felt, data: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, data_len, data);`,
      `   emit_event(keys_len, keys, data_len, data);`,
      `   return ();`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.starknet.common.syscalls', 'emit_event');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin');

    this.generatedFunctions.set(key, { name: `_emit_${key}`, code: code });
    return `_emit_${key}`;
  }

  private generateAnonymizeCode(isAnonymous: boolean, topic: BigInt, eventSig: string): string {
    this.requireImport('warplib.keccak', 'felt_array_concat');
    if (isAnonymous) {
      return [`    let keys_len = keys_wt_len;`, `    let keys = keys_wt;`].join('\n');
    }
    return [
      `    let keys_len = 1;`,
      `    let (keys: felt*) = alloc();// keccak of event signature: ${eventSig}`,
      `    assert keys[0] = ${topic};`,
      `    let (keys_len: felt) = felt_array_concat(keys_wt_len, 0, keys_wt, keys_len, keys);`,
    ].join('\n');
  }

  private generateInsertionCode(type: TypeNode, arrayName: string, argName: string): string {
    const abiFunc = this.abiEncode.getOrCreate([type]);

    this.requireImport('warplib.memory', 'wm_to_felt_array');
    this.requireImport('warplib.keccak', 'pack_bytes_felt');
    this.requireImport('warplib.keccak', 'felt_array_concat');

    return [
      `   let (mem_encode: felt) = ${abiFunc}(${argName});`,
      `   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);`,
      `   let (${arrayName}_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, ${arrayName}_len, ${arrayName});`,
    ].join('\n');
  }
}
