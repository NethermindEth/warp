import assert from 'assert';
import {
  AddressType,
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  PointerType,
  SourceUnit,
  StringType,
  StructDefinition,
  TupleType,
  TypeNameType,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import {
  getByteSize,
  getElementType,
  getPackedByteSize,
  isDynamicallySized,
  isDynamicArray,
  isReferenceType,
  isValueType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, StringIndexedFuncGenWithAuxiliar } from '../base';
import { MemoryWriteGen } from '../export';
import { removeSizeInfo } from './base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

export class AbiDecode extends StringIndexedFuncGenWithAuxiliar {
  protected functionName = 'abi_decode';
  protected memoryWrite: MemoryWriteGen;

  constructor(memoryWrite: MemoryWriteGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.memoryWrite = memoryWrite;
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

    const [returnParams, decodings] = types.reduce(
      ([returnParams, decodings], type, index) => [
        [
          ...returnParams,
          {
            name: `result${index}`,
            type: CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).toString(),
          },
        ],
        [
          ...decodings,
          this.generateDecodingCode(type, 'mem_index', `result${index}`),
          `let in_range${index} = is_le_felt(mem_index, max_index_length);`,
          `in_range${index} = 1;`,
        ],
      ],
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const indexLength = types.reduce(
      (sum, t) => sum + BigInt(getByteSize(t, this.ast.compilerVersion)),
      0n,
    );

    const returnCairoParams = returnParams.map((r) => `${r.name} : ${r.type}`).join(',');
    const returnValues = returnParams.map((r) => `${r.name} = ${r.name}`).join(',');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(mem_ptr : felt) -> (${returnCairoParams}){`,
      `  alloc_locals;`,
      `  let (max_length256: Uint256) = wm_dyn_array_length(mem_ptr);`,
      `  let (max_length: felt) = narrow_safe(max_length256);`,
      `  let (max_index_length: felt) = ${indexLength}`,
      `  let mem_index : felt = 0;`,
      ...decodings,
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
      (type) => this.createDynamicArrayDecoding(type),
      (type) => this.createStaticArrayDecoding(type),
      unexpectedType,
      unexpectedType,
      (type) => this.createValueTypeDecoding(getPackedByteSize(type, this.ast.compilerVersion)),
    );
  }

  public generateDecodingCode(type: TypeNode, newIndexVar: string, decodeResult: string): string {
    assert(
      !(type instanceof PointerType),
      'Pointer types are not valid types for decoding. Try to generalize them',
    );

    // address types get special treatment due to different byte size in ethereum and starknet
    if (type instanceof AddressType) {
      const funcName = this.createValueTypeDecoding(31);
      return [
        `let (${decodeResult} : felt) = ${funcName}(mem_index, mem_index + 32, mem_ptr, 0);`,
        `let ${newIndexVar} = mem_index + 32;`,
      ].join('\n');
    }

    const funcName = this.getOrCreateDecoding(type);

    if (isReferenceType(type)) {
      // Handle in what position starts the value to be decode
      // Standard value types, or reference types which size can be known in compile
      // time are encoded in place (like structs of value types and static array of
      // value types)
      // When is a dynamic array or a nested reference type, then the actual location
      // is further in the byte array. That loation can be read in the current
      // [mem_index, mem_index + 32] range of the byte array
      let initInstructions: string[] = [];
      let typeIndex: string = 'mem_index';
      if (isDynamicallySized(type, this.ast.compilerVersion)) {
        this.requireImport('warplib.dynamic_arrays_util', 'byte_array_to_felt_value');
        initInstructions = [
          `let (param_offset) = byte_array_to_felt_value(mem_index, mem_index + 32, mem_ptr, 0);`,
          `let (mem_offset) = mem_index + param_offset;`,
        ];
        typeIndex = 'mem_offset';
      }

      // Handle the initialization of arguments and call of the corresponding
      // decoding function.
      let callInstructions: string[];
      if (isDynamicArray(type)) {
        const elementTWidth = CairoType.fromSol(getElementType(type), this.ast).width;
        callInstructions = [
          `let dyn_array_length = bytes_array_to_felt_value(`,
          `  ${typeIndex},`,
          `  ${typeIndex} + 32,`,
          `  mem_ptr,`,
          `  0`,
          `);`,
          `let (dyn_array_length256) = felt_to_uint256(dyn_array_length);`,
          `let dyn_array_ptr = wm_new(dyn_array_length256, ${uint256(elementTWidth)})`,
          `let (${decodeResult}) = ${funcName}(`,
          `  ${typeIndex} + 32,`,
          `  mem_ptr,`,
          `  0,`,
          `  dyn_array_length,`,
          `  dyn_array_ptr`,
          `);`,
        ];
        // Other relevant imports get added when the function is generated
        this.requireImport('warplib.memory', 'wm_new');
      } else if (type instanceof ArrayType) {
        // Handling static arrays
        assert(type.size !== undefined);
        const elemenTWidth = BigInt(CairoType.fromSol(type.elementT, this.ast).width);
        callInstructions = [
          `let (array_ptr) = wm_alloc(${uint256(type.size * elemenTWidth)})`,
          `let (${decodeResult}) = ${funcName}(`,
          `  ${typeIndex},`,
          `  mem_ptr,`,
          `  0,`,
          `  ${type.size},`,
          `  array_ptr`,
          `);`,
        ];
      } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
        callInstructions = [];
      } else {
        throw new TranspileFailedError(
          `Unexpected reference type to generate decoding code: ${printTypeNode(type)}`,
        );
      }

      return [
        ...initInstructions,
        ...callInstructions,
        `let ${newIndexVar} = mem_index + ${getByteSize(type, this.ast.compilerVersion)}`,
      ].join('\n');
    }

    // Handling value types
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

  private createStaticArrayDecoding(type: ArrayType) {
    assert(type.size !== undefined);
    const key = removeSizeInfo(type);
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const elementTWidth = CairoType.fromSol(type.elementT, this.ast);

    const decodingCode = this.generateDecodingCode(type.elementT, 'next_mem_index', 'element');
    const getMemLocCode = `let (write_to_mem_location) = felt_to_uint256(array_ptr + array_index * ${elementTWidth})`;
    const writeToMemCode = `${this.memoryWrite.getOrCreate(
      type.elementT,
    )}(write_to_mem_location, element)`;

    const name = `${this.functionName}_static_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  mem_index: felt,`,
      `  mem_ptr: felt,`,
      `  array_index: felt,`,
      `  array_length: felt,`,
      `  array_ptr: felt,`,
      `){`,
      `  if (array_index == array_length) {`,
      `    return ();`,
      `  }`,
      `  ${decodingCode}`,
      `  ${getMemLocCode}`,
      `  ${writeToMemCode}`,
      `  return ${name}(next_mem_index, mem_ptr, array_index + 1, array_length, array_ptr)`,
      `}`,
    ].join('\n');

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createDynamicArrayDecoding(type: ArrayType | StringType | BytesType): string {
    const key = type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const elementT = getElementType(type);
    const elemenTWidth = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.CallDataRef,
    ).width;

    const decodingCode = this.generateDecodingCode(elementT, 'next_mem_index', 'element');
    const getMemLocCode = [
      `let dyn_array_index256 = felt_to_uint256(dyn_array_index);`,
      `let (write_to_mem_location) = wm_index_dyn(dyn_array_ptr, dyn_array_index256, ${uint256(
        elemenTWidth,
      )});`,
    ].join('\n');
    const writeToMemCode = `${this.memoryWrite.getOrCreate(
      elementT,
    )}(write_to_mem_location, element)`;

    const name = `${this.functionName}_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  mem_index: felt,`,
      `  mem_ptr: felt,`,
      `  dyn_array_index: felt,`,
      `  dyn_array_length: felt,`,
      `  dyn_array_ptr: felt`,
      `){`,
      `  alloc_locals;`,
      `  if (dyn_array_index == dyn_array_length){`,
      `    return ()`,
      `  }`,
      `  ${decodingCode}`,
      `  ${getMemLocCode}`,
      `  ${writeToMemCode}`,
      `  return ${name}(`,
      `    next_mem_index,`,
      `    mem_ptr,`,
      `    dyn_array_index + 1,`,
      `    dyn_array_length,`,
      `    dyn_array_ptr`,
      `  );`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStructDecoding(type: UserDefinedType, definition: StructDefinition) {}

  private createValueTypeDecoding(byteSize: number | bigint): string {
    const funcName = byteSize === 32 ? 'byte_array_to_uint256_value' : 'byte_array_to_felt_value';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }
}
