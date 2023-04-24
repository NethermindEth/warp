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
import {
  ALLOC,
  BITWISE_BUILTIN,
  EMIT_EVENT,
  FELT_ARRAY_CONCAT,
  FELT_TO_UINT256,
  FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY_SPL,
  PACK_BYTES_FELT,
  U128_FROM_FELT,
  WARP_KECCAK,
  WM_TO_FELT_ARRAY,
} from '../utils/importPaths';
import endent from 'endent';

export const BYTES_IN_FELT_PACKING = 31;
const BIG_ENDIAN = 1; // 0 for little endian, used for packing of bytes (31 byte felts -> a 248 bit felt)

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
    const code = endent`
      #[implicit(warp_memory)]
      func ${EMIT_PREFIX}${suffix}(${cairoParams}){
        alloc_locals;
        // keys arrays
        let keys_len: felt = 0;
        let (keys: felt*) = alloc();
        //Insert topic
        ${anonymousCode}
        ${keysInsertions.join('\n')}
        // keys: pack 31 byte felts into a single 248 bit felt
        let (keys_len: felt, keys: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, keys_len, keys);
        // data arrays
        let data_len: felt = 0;
        let (data: felt*) = alloc();
        ${dataInsertions}
        // data: pack 31 bytes felts into a single 248 bits felt
        let (data_len: felt, data: felt*) = pack_bytes_felt(${BYTES_IN_FELT_PACKING}, ${BIG_ENDIAN}, data_len, data);
        emit_event(keys_len, keys, data_len, data);
        return ();
      }
    `;

    const funcInfo: GeneratedFunctionInfo = {
      name: `${EMIT_PREFIX}${suffix}`,
      code: code,
      functionsCalled: [
        this.requireImport(...EMIT_EVENT),
        this.requireImport(...ALLOC),
        this.requireImport(...PACK_BYTES_FELT),
        this.requireImport(...BITWISE_BUILTIN),
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
      return [`// Event is anonymous, topic won't be added to keys`, []];
    }
    return [
      endent`
        let topic256: Uint256 = Uint256(${topic.low}, ${topic.high});// keccak of event signature: ${eventSig}
        let (keys_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(keys_len, keys, 0, topic256);
      `,
      [
        this.requireImport(...U128_FROM_FELT),
        this.requireImport(...FELT_TO_UINT256),
        this.requireImport(...FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY_SPL),
      ],
    ];
  }

  private generateSimpleEncodingCode(
    types: TypeNode[],
    arrayName: string,
    argNames: string[],
  ): [string, CairoFunctionDefinition[]] {
    const abiFunc = this.abiEncode.getOrCreateFuncDef(types);

    this.requireImport(...WM_TO_FELT_ARRAY);
    this.requireImport(...FELT_ARRAY_CONCAT);

    return [
      endent`
        let (mem_encode: felt) = ${abiFunc.name}(${argNames.join(',')});
        let (encode_bytes_len: felt, encode_bytes: felt*) = wm_to_felt_array(mem_encode);
        let (${arrayName}_len: felt) = felt_array_concat(encode_bytes_len, 0, encode_bytes, ${arrayName}_len, ${arrayName});
      `,
      [this.requireImport(...WM_TO_FELT_ARRAY), this.requireImport(...FELT_ARRAY_CONCAT), abiFunc],
    ];
  }

  private generateComplexEncodingCode(
    types: TypeNode[],
    arrayName: string,
    argNames: string[],
  ): [string, CairoFunctionDefinition[]] {
    const abiFunc = this.indexEncode.getOrCreateFuncDef(types);

    return [
      endent`
          let (mem_encode: felt) = ${abiFunc.name}(${argNames.join(',')});
          let (keccak_hash256: Uint256) = warp_keccak(mem_encode);
          let (${arrayName}_len: felt) = fixed_bytes256_to_felt_dynamic_array_spl(${arrayName}_len, ${arrayName}, 0, keccak_hash256);
      `,
      [
        this.requireImport(...U128_FROM_FELT),
        this.requireImport(...FELT_TO_UINT256),
        this.requireImport(...WARP_KECCAK),
        this.requireImport(...FIXED_BYTES256_TO_FELT_DYNAMIC_ARRAY_SPL),
        abiFunc,
      ],
    ];
  }
}
