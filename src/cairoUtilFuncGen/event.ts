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
  AST,
  CairoType,
  createCallToFunction,
  isValueType,
  safeGetNodeType,
  TypeConversionContext,
  typeNameFromTypeNode,
  createCairoGeneratedFunction,
  warpEventSignatureHash256FromString,
  EMIT_PREFIX,
  CairoFunctionDefinition,
} from '../export';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from './base';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AbiEncode } from './abi/abiEncode';
import { IndexEncode } from './abi/indexEncode';

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
    const funcDef = this.getOrCreateFuncDef(refEventDef, argsTypes);
    return createCallToFunction(funcDef, node.vEventCall.vArguments, this.ast);
  }
  private getOrCreateFuncDef(eventDef: EventDefinition, argsTypes: TypeNode[]) {
    const key = `${eventDef.name}_${this.ast.inference.signatureHash(
      eventDef,
      ABIEncoderVersion.V2,
    )}`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }
    const funcInfo = this.getOrCreate(eventDef);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      argsTypes.map((argT, index) =>
        isValueType(argT)
          ? [`param${index}`, typeNameFromTypeNode(argT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(argT, this.ast), DataLocation.Memory],
      ),
      [],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(node: EventDefinition) {
    // Add the canonicalSignatureHash so that generated function names don't collide when overloaded
    const [params, keysInsertions, dataParams, dataParamTypes, requiredFuncs] =
      node.vParameters.vParameters.reduce(
        ([params, keysInsertions, dataParams, dataParamTypes, requiredFuncs], param, index) => {
          const paramType = generalizeType(safeGetNodeType(param, this.ast.inference))[0];
          const cairoType = CairoType.fromSol(paramType, this.ast, TypeConversionContext.Ref);

          params.push({ name: `param${index}`, type: cairoType.toString() });

          if (param.indexed) {
            // An indexed parameter should go to the keys array
            if (isValueType(paramType)) {
              // If the parameter is a value type, we can just add it to the keys array
              // as it is, as we do regular abi encoding
              const [code, calledFuncs] = this.generateSimpleEncodingCode([paramType], 'keys', [
                `param${index}`,
              ]);
              keysInsertions.push(code);
              requiredFuncs.push(...calledFuncs);
            } else {
              // If the parameter is a reference type, we hash the with special encoding
              // function: more at:
              //   https://docs.soliditylang.org/en/v0.8.14/abi-spec.html#encoding-of-indexed-event-parameters
              const [code, calledFuncs] = this.generateComplexEncodingCode([paramType], 'keys', [
                `param${index}`,
              ]);
              keysInsertions.push(code);
              requiredFuncs.push(...calledFuncs);
            }
          } else {
            // A non-indexed parameter should go to the data array
            dataParams.push(`param${index}`);
            dataParamTypes.push(paramType);
          }

          return [params, keysInsertions, dataParams, dataParamTypes, requiredFuncs];
        },
        [
          new Array<{ name: string; type: string }>(),
          new Array<string>(),
          new Array<string>(),
          new Array<TypeNode>(),
          new Array<CairoFunctionDefinition>(),
        ],
      );

    const [dataInsertions, dataInsertionsCalls] = this.generateSimpleEncodingCode(
      dataParamTypes,
      'data',
      dataParams,
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');

    const topic: { low: string; high: string } = warpEventSignatureHash256FromString(
      this.ast.inference.signature(node, ABIEncoderVersion.V2),
    );

    const [anonymousCode, anonymousCalls] = this.generateAnonymizeCode(
      node.anonymous,
      topic,
      this.ast.inference.signature(node, ABIEncoderVersion.V2),
    );
    const suffix = `${node.name}_${this.ast.inference.signatureHash(node, ABIEncoderVersion.V2)}`;
    const code = [
      `func ${EMIT_PREFIX}${suffix}${IMPLICITS}(${cairoParams}){`,
      `   alloc_locals;`,
      `   // keys arrays`,
      `   let keys_len: felt = 0;`,
      `   let (keys: felt*) = alloc();`,
      `   //Insert topic`,
      anonymousCode,
      ...keysInsertions,
      `   // keys: pack 31 byte felts into a single 248 bit felt`,
      `   let (keys_len: felt, keys: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, keys_len, keys);`,
      `   // data arrays`,
      `   let data_len: felt = 0;`,
      `   let (data: felt*) = alloc();`,
      dataInsertions,
      `   // data: pack 31 bytes felts into a single 248 bits felt`,
      `   let (data_len: felt, data: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, data_len, data);`,
      `   emit_event(keys_len, keys, data_len, data);`,
      `   return ();`,
      `}`,
    ].join('\n');

    const funcInfo: GeneratedFunctionInfo = {
      name: `${EMIT_PREFIX}${suffix}`,
      code: code,
      functionsCalled: [
        this.requireImport('starkware.starknet.common.syscalls', 'emit_event'),
        this.requireImport('starkware.cairo.common.alloc', 'alloc'),
        this.requireImport('warplib.keccak', 'pack_bytes_felt'),
        this.requireImport('starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin'),
        ...requiredFuncs,
        ...dataInsertionsCalls,
        ...anonymousCalls,
      ],
    };
    return funcInfo;
  }

  private generateAnonymizeCode(
    isAnonymous: boolean,
    topic: { low: string; high: string },
    eventSig: string,
  ): [string, CairoFunctionDefinition[]] {
    if (isAnonymous) {
      return [[`// Event is anonymous, topic won't be added to keys`].join('\n'), []];
    }
    return [
      [
        `    let topic256: Uint256 = Uint256(${topic.low}, ${topic.high});// keccak of event signature: ${eventSig}`,
        `    let (keys_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(keys_len, keys, 0, topic256);`,
      ].join('\n'),
      [
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        this.requireImport(`warplib.maths.utils`, 'felt_to_uint256'),
        this.requireImport(
          'warplib.dynamic_arrays_util',
          'fixed_bytes256_to_felt_dynamic_array_spl',
        ),
      ],
    ];
  }

  private generateSimpleEncodingCode(
    types: TypeNode[],
    arrayName: string,
    argNames: string[],
  ): [string, CairoFunctionDefinition[]] {
    const abiFunc = this.abiEncode.getOrCreateFuncDef(types);

    this.requireImport('warplib.memory', 'wm_to_felt_array');
    this.requireImport('warplib.keccak', 'felt_array_concat');

    return [
      [
        `   let (mem_encode: felt) = ${abiFunc.name}(${argNames.join(',')});`,
        `   let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);`,
        `   let (${arrayName}_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, ${arrayName}_len, ${arrayName});`,
      ].join('\n'),
      [
        this.requireImport('warplib.memory', 'wm_to_felt_array'),
        this.requireImport('warplib.keccak', 'felt_array_concat'),
        abiFunc,
      ],
    ];
  }

  private generateComplexEncodingCode(
    types: TypeNode[],
    arrayName: string,
    argNames: string[],
  ): [string, CairoFunctionDefinition[]] {
    const abiFunc = this.indexEncode.getOrCreateFuncDef(types);

    return [
      [
        `   let (mem_encode: felt) = ${abiFunc.name}(${argNames.join(',')});`,
        `   let (keccak_hash256: Uint256) = warp_keccak(mem_encode);`,
        `   let (${arrayName}_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(${arrayName}_len, ${arrayName}, 0, keccak_hash256);`,
      ].join('\n'),
      [
        this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
        this.requireImport(`warplib.maths.utils`, 'felt_to_uint256'),
        this.requireImport('warplib.keccak', 'warp_keccak'),
        this.requireImport(
          'warplib.dynamic_arrays_util',
          'fixed_bytes256_to_felt_dynamic_array_spl',
        ),
        abiFunc,
      ],
    ];
  }
}
