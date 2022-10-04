import assert from 'assert';
import {
  AddressType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  SourceUnit,
  TupleType,
  TypeNameType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import { getPackedByteSize, isValueType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, delegateBasedOnType, StringIndexedFuncGenWithAuxiliar } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class AbiDecode extends StringIndexedFuncGenWithAuxiliar {
  protected functionName = 'abi_decode';
  protected memoryRead: MemoryReadGen;

  constructor(memoryRead: MemoryReadGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.memoryRead = memoryRead;
  }

  public gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
    assert(
      expressions.length === 2,
      'ABI decode must recieve two arguments: data to decode, and types to decode into',
    );
    const [data, types] = expressions.map(
      (t) => generalizeType(safeGetNodeType(t, this.ast.compilerVersion))[0],
    );
    assert(
      data instanceof BytesType,
      `Data must be of BytesType instead of ${printTypeNode(data)}`,
    );
    assert(
      types instanceof TupleType || types instanceof TypeNameType,
      `Types must be of TupleType or TypeNameType instead of ${printTypeNode(types)}`,
    );
    const typesToDecode =
      types instanceof TupleType
        ? types.elements.map((t) => {
            assert(t instanceof TypeNameType);
            return t.type;
          })
        : [types.type];

    const functionName = this.getOrCreate(typesToDecode);

    const functionStub = createCairoFunctionStub(
      functionName,
      [['data', createBytesTypeName(this.ast), DataLocation.Memory]],
      typesToDecode.map((t, index) =>
        isValueType(t)
          ? [`result${index}`, typeNameFromTypeNode(t, this.ast)]
          : [`result${index}`, typeNameFromTypeNode(t, this.ast), DataLocation.Memory],
      ),
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );

    return createCallToFunction(functionStub, [expressions[0]], this.ast);
  }

  public getOrCreate(types: TypeNode[]): string {
    const key = types.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [returnParams, encodings] = types.reduce(
      ([returnParams, encodings], type, index) => [
        [
          ...returnParams,
          {
            name: `result${index}`,
            type: CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).toString(),
          },
        ],
        [
          ...encodings,
          this.generateDecodingCode(type, 'mem_index', `result${index}`),
          `let in_range${index} =  is_le_felt(mem_index, mem_length);`,
          `in_range${index} = 1;`,
        ],
      ],
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const returnCairoParams = returnParams.map((r) => `${r.name} : ${r.type}`).join(',');
    const returnValues = returnParams.map((r) => `${r.name} = ${r.name}`).join(',');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(mem_ptr : felt) -> (${returnCairoParams}){`,
      `  alloc_locals;`,
      `  let (mem_length256 : Uint256) = wm_dyn_array_length(mem_ptr);`,
      `  let (mem_length : felt) = narrow_safe(mem_length256);`,
      `  let mem_index : felt = 0;`,
      ...encodings,
      ` return (${returnValues});`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.math_cmp', 'is_le_felt');
    this.requireImport('warplib.memory', 'wm_dyn_array_length');
    this.requireImport('warplib.memory', 'wm_read_id');
    this.requireImport('warplib.maths.utils', 'narrow_safe');

    const cairoFunc = { name: funcName, code: code };
    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  public getOrCreateDecoding(type: TypeNode): string {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported yet`);
    };

    return delegateBasedOnType<string>(
      type,
      unexpectedType,
      unexpectedType,
      unexpectedType,
      unexpectedType,
      (type) => this.createValueTypeDecoding(getPackedByteSize(type, this.ast.compilerVersion)),
    );
  }

  public generateDecodingCode(type: TypeNode, newIndexVar: string, decodeResult: string): string {
    // address types get special treatment due to different bit size in ethereum and starknet
    if (type instanceof AddressType) {
      const funcName = this.createValueTypeDecoding(31);
      return [
        `let (${decodeResult} : felt) = ${funcName}(mem_index, mem_index + 32, mem_ptr, 0);`,
        `let ${newIndexVar} = mem_index + 32;`,
      ].join('\n');
    }

    const funcName = this.getOrCreateDecoding(type);

    // Only value types as for now
    const byteSize = Number(getPackedByteSize(type, this.ast.compilerVersion));
    const args = [
      add('mem_index', 32 - byteSize),
      'mem_index + 32',
      'mem_ptr',
      '0', // inital accumulator
    ];

    if (byteSize === 32) {
      args.push('0');
      this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    }
    const decodeType = byteSize === 32 ? 'Uint256' : 'felt';

    return [
      `let (${decodeResult} : ${decodeType}) = ${funcName}(${args.join(',')});`,
      `let ${newIndexVar} = mem_index + 32;`,
    ].join('\n');
  }

  private createValueTypeDecoding(byteSize: number | bigint): string {
    const funcName = byteSize === 32 ? 'byte_array_to_uint256_value' : 'byte_array_to_felt_value';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }
}
