import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  PointerType,
  SourceUnit,
  StructDefinition,
  TupleType,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import {
  getByteSize,
  getElementType,
  getPackedByteSize,
  isAddressType,
  isDynamicallySized,
  isDynamicArray,
  isReferenceType,
  isValueType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, mul, StringIndexedFuncGenWithAuxiliar } from '../base';
import { MemoryWriteGen, parseCairoImplicits } from '../export';
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
      (t) => generalizeType(safeGetNodeType(t, this.ast.inference))[0],
    );
    assert(
      data instanceof BytesType,
      `Data must be of BytesType instead of ${printTypeNode(data)}`,
    );
    const typesToDecode = types instanceof TupleType ? types.elements : [types];

    const functionName = this.getOrCreate(typesToDecode.map((t) => generalizeType(t)[0]));

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

    const [returnParams, decodings, functionsCalled] = types.reduce(
      ([returnParams, decodings, functionsCalled], type, index) => {
        const newReturnParams = [
          ...returnParams,
          {
            name: `result${index}`,
            type: CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).toString(),
          },
        ];
        const [newDecodings, newFunctionsCalled] = this.generateDecodingCode(
          type,
          'mem_index',
          `result${index}`,
          'mem_index',
        );
        return [
          newReturnParams,
          [...decodings, `// Param ${index} decoding:`, newDecodings],
          [...functionsCalled, ...newFunctionsCalled],
        ];
      },
      [
        new Array<{ name: string; type: string }>(),
        new Array<string>(),
        new Array<CairoFunctionDefinition>(),
      ],
    );

    const indexLength = types.reduce(
      (sum, t) => sum + BigInt(getByteSize(t, this.ast.inference)),
      0n,
    );

    const returnCairoParams = returnParams.map((r) => `${r.name} : ${r.type}`).join(',');
    const returnValues = returnParams.map((r) => `${r.name} = ${r.name}`).join(',');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(mem_ptr : felt) -> (${returnCairoParams}){`,
      `  alloc_locals;`,
      `  let max_index_length: felt = ${indexLength};`,
      `  let mem_index: felt = 0;`,
      ...decodings,
      `  assert max_index_length - mem_index = 0;`,
      ` return (${returnValues});`,
      `}`,
    ].join('\n');

    const cairoFunc = { name: funcName, code: code, functionsCalled: functionsCalled };
    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  public getOrCreateDecoding(type: TypeNode): CairoFunctionDefinition {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Decoding of ${printTypeNode(type)} is not valid`);
    };

    return delegateBasedOnType<CairoFunctionDefinition>(
      type,
      (type) =>
        type instanceof ArrayType
          ? this.createDynamicArrayDecoding(type)
          : this.createStringBytesDecoding(),
      (type) => this.createStaticArrayDecoding(type),
      (type, definition) => this.createStructDecoding(type, definition),
      unexpectedType,
      (type) => this.createValueTypeDecoding(getPackedByteSize(type, this.ast.inference)),
    );
  }

  /**
   * Given a type it generates the arguments and function to decode such type from a warp memory byte array
   * @param type type to decode
   * @param newIndexVar cairo var to store new index position after decoding the type
   * @param decodeResult cairo var that stores the result of the decoding
   * @param relativeIndexVar cairo var to handle offset values
   * @returns the generated code and functions called
   */
  public generateDecodingCode(
    type: TypeNode,
    newIndexVar: string,
    decodeResult: string,
    relativeIndexVar: string,
  ): [string, CairoFunctionDefinition[]] {
    assert(
      !(type instanceof PointerType),
      'Pointer types are not valid types for decoding. Try to generalize them',
    );

    // address types get special treatment due to different byte size in ethereum and starknet
    if (isAddressType(type)) {
      const func = this.createValueTypeDecoding(31);
      return [
        [
          `let (${decodeResult} : felt) = ${func.name}(mem_index, mem_index + 32, mem_ptr, 0);`,
          `let ${newIndexVar} = mem_index + 32;`,
        ].join('\n'),
        [func],
      ];
    }

    const auxFunc = this.getOrCreateDecoding(type);
    const importedFuncs = [];

    if (isReferenceType(type)) {
      // Find where the type is encoded in the bytes array:
      //  - Value types, or reference types which size can be known in compile
      //    time are encoded in place (like structs of value types and static array of
      //    value types)
      //  - Dynamic arrays or nested reference types actual location is encoded at
      //    the current location (i.e. [mem_index, mem_index + 32]). After reading the
      //    actual location, the decoding process starts from there.
      let initInstructions: string[] = [];
      let typeIndex = 'mem_index';
      if (isDynamicallySized(type, this.ast.inference)) {
        importedFuncs.push(
          this.requireImport('warplib.dynamic_arrays_util', 'byte_array_to_felt_value'),
        );
        initInstructions = [
          `let (param_offset) = byte_array_to_felt_value(mem_index, mem_index + 32, mem_ptr, 0);`,
          `let mem_offset = ${calcOffset('mem_index', 'param_offset', relativeIndexVar)};`,
        ];
        typeIndex = 'mem_offset';
      }

      // Handle the initialization of arguments and call of the corresponding
      // decoding function.
      let callInstructions: string[];
      if (isDynamicArray(type)) {
        const elementTWidth = CairoType.fromSol(
          getElementType(type),
          this.ast,
          TypeConversionContext.Ref,
        ).width;
        callInstructions = [
          `let (${decodeResult}_dyn_array_length) = byte_array_to_felt_value(`,
          `  ${typeIndex},`,
          `  ${typeIndex} + 32,`,
          `  mem_ptr,`,
          `  0`,
          `);`,
          `let (${decodeResult}_dyn_array_length256) = felt_to_uint256(${decodeResult}_dyn_array_length);`,
          `let (${decodeResult}) = wm_new(${decodeResult}_dyn_array_length256, ${uint256(
            elementTWidth,
          )});`,
          `${auxFunc.name}(`,
          `  ${typeIndex} + 32,`,
          `  mem_ptr,`,
          `  0,`,
          `  ${decodeResult}_dyn_array_length,`,
          `  ${decodeResult}`,
          `);`,
        ];
        // Other relevant imports get added when the function is generated
        importedFuncs.push(this.requireImport('warplib.memory', 'wm_new'));
      } else if (type instanceof ArrayType) {
        // Handling static arrays
        assert(type.size !== undefined);
        const elemenTWidth = BigInt(
          CairoType.fromSol(type.elementT, this.ast, TypeConversionContext.Ref).width,
        );
        callInstructions = [
          `let (${decodeResult}) = wm_alloc(${uint256(type.size * elemenTWidth)});`,
          `${auxFunc.name}(`,
          `  ${typeIndex},`,
          `  mem_ptr,`,
          `  0,`,
          `  ${type.size},`,
          `  ${decodeResult}`,
          `);`,
        ];
        importedFuncs.push(this.requireImport('warplib.memory', 'wm_alloc'));
      } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
        const maxSize = CairoType.fromSol(
          type,
          this.ast,
          TypeConversionContext.MemoryAllocation,
        ).width;
        callInstructions = [
          `let (${decodeResult}) = wm_alloc(${uint256(maxSize)});`,
          `${auxFunc.name}(`,
          `  ${typeIndex},`,
          `  mem_ptr,`,
          `  ${decodeResult}`,
          `);`,
        ];
        importedFuncs.push(this.requireImport('warplib.memory', 'wm_alloc'));
      } else {
        throw new TranspileFailedError(
          `Unexpected reference type to generate decoding code: ${printTypeNode(type)}`,
        );
      }

      return [
        [
          ...initInstructions,
          ...callInstructions,
          `let ${newIndexVar} = mem_index + ${getByteSize(type, this.ast.inference)};`,
        ].join('\n'),
        [...importedFuncs, auxFunc],
      ];
    }

    // Handling value types
    const byteSize = Number(getPackedByteSize(type, this.ast.inference));
    const args = [
      add('mem_index', 32 - byteSize),
      'mem_index + 32',
      'mem_ptr',
      '0', // inital accumulator
    ];

    if (byteSize === 32) {
      args.push('0');
      importedFuncs.push(this.requireImport('starkware.cairo.common.uint256', 'Uint256'));
    }
    const decodeType = byteSize === 32 ? 'Uint256' : 'felt';

    return [
      [
        `let (${decodeResult} : ${decodeType}) = ${auxFunc.name}(${args.join(',')});`,
        `let ${newIndexVar} = mem_index + 32;`,
      ].join('\n'),
      [...importedFuncs, auxFunc],
    ];
  }

  private createStaticArrayDecoding(type: ArrayType): CairoFunctionDefinition {
    assert(type.size !== undefined);
    const key = 'static' + removeSizeInfo(type);
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementTWidth = CairoType.fromSol(type.elementT, this.ast).width;

    const [decodingCode, functionsCalled] = this.generateDecodingCode(
      type.elementT,
      'next_mem_index',
      'element',
      '32 * array_index',
    );
    const getMemLocCode = `let write_to_mem_location = array_ptr + ${mul(
      'array_index',
      elementTWidth,
    )};`;
    const writeToMemCode = `${this.memoryWrite.getOrCreate(
      type.elementT,
    )}(write_to_mem_location, element);`;

    const name = `${this.functionName}_static_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  mem_index: felt,`,
      `  mem_ptr: felt,`,
      `  array_index: felt,`,
      `  array_length: felt,`,
      `  array_ptr: felt,`,
      `){`,
      `  alloc_locals;`,
      `  if (array_index == array_length) {`,
      `    return ();`,
      `  }`,
      `  ${decodingCode}`,
      `  ${getMemLocCode}`,
      `  ${writeToMemCode}`,
      `  return ${name}(next_mem_index, mem_ptr, array_index + 1, array_length, array_ptr);`,
      `}`,
    ].join('\n');

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    const funcInfo = { name, code, functionsCalled };
    const generatedFunc = createCairoGeneratedFunction(
      funcInfo,
      [],
      [],
      parseCairoImplicits(IMPLICITS),
      this.ast,
      this.sourceUnit,
    );

    this.auxiliarGeneratedFunctions.set(key, generatedFunc);
    return generatedFunc;
  }

  private createDynamicArrayDecoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'dynamic' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementT = getElementType(type);
    const elemenTWidth = CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref).width;

    const [decodingCode, functionsCalled] = this.generateDecodingCode(
      elementT,
      'next_mem_index',
      'element',
      '32 * dyn_array_index',
    );
    const getMemLocCode = [
      `let (dyn_array_index256) = felt_to_uint256(dyn_array_index);`,
      `let (write_to_mem_location) = wm_index_dyn(dyn_array_ptr, dyn_array_index256, ${uint256(
        elemenTWidth,
      )});`,
    ].join('\n');
    const writeToMemCode = `${this.memoryWrite.getOrCreate(
      elementT,
    )}(write_to_mem_location, element);`;

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
      `    return ();`,
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

    const importedFuncs = [
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('warplib.memory', 'wm_index_dyn'),
      this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
      this.requireImport('warplib.maths.utils', 'narrow_safe'),
    ];

    const funcInfo = { name, code, functionsCalled: [...importedFuncs, ...functionsCalled] };
    const generatedFunc = createCairoGeneratedFunction(
      funcInfo,
      [],
      [],
      parseCairoImplicits(IMPLICITS),
      this.ast,
      this.sourceUnit,
    );

    this.auxiliarGeneratedFunctions.set(key, generatedFunc);
    return generatedFunc;
  }

  private createStructDecoding(
    type: UserDefinedType,
    definition: StructDefinition,
  ): CairoFunctionDefinition {
    const key = type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    let indexWalked = 0;
    let structWriteLocation = 0;
    const decodingInfo: [string, CairoFunctionDefinition[]][] = definition.vMembers.map(
      (member, index) => {
        const type = generalizeType(safeGetNodeType(member, this.ast.inference))[0];
        const elemWidth = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref).width;
        const [decodingCode, functionsCalled] = this.generateDecodingCode(
          type,
          'mem_index',
          `member${index}`,
          `${indexWalked}`,
        );
        indexWalked += Number(getByteSize(type, this.ast.inference));
        structWriteLocation += index * elemWidth;
        const getMemLocCode = `let mem_to_write_loc = ${add('struct_ptr', structWriteLocation)};`;
        const writeMemLocCode = `${this.memoryWrite.getOrCreate(
          type,
        )}(mem_to_write_loc, member${index});`;
        return [
          [
            `// Decoding member ${member.name}`,
            `${decodingCode}`,
            `${getMemLocCode}`,
            `${writeMemLocCode}`,
          ].join('\n'),
          functionsCalled,
        ];
      },
    );

    const [instructions, functionsCalled] = decodingInfo.reduce(
      ([instructions, functionsCalled], [currentInstruction, currentFuncs]) => [
        [...instructions, currentInstruction],
        [...functionsCalled, ...currentFuncs],
      ],
      [new Array<String>(), new Array<CairoFunctionDefinition>()],
    );

    const name = `${this.functionName}_struct_${definition.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  mem_index: felt,`,
      `  mem_ptr: felt,`,
      `  struct_ptr: felt`,
      `){`,
      `  alloc_locals;`,
      ...instructions,
      `  return ();`,
      `}`,
    ].join('\n');

    const importedFuncs = [this.requireImport('warplib.maths.utils', 'felt_to_uint256')];
    const genFuncInfo = { name, code, functionsCalled: [...importedFuncs, ...functionsCalled] };
    const auxFunc = createCairoGeneratedFunction(
      genFuncInfo,
      [],
      [],
      [],
      this.ast,
      this.sourceUnit,
    );

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStringBytesDecoding(): CairoFunctionDefinition {
    const funcName = 'memory_dyn_array_copy';
    const importedFunc = this.requireImport('warplib.dynamic_arrays_util', funcName);
    return importedFunc;
  }

  private createValueTypeDecoding(byteSize: number | bigint): CairoFunctionDefinition {
    const funcName = byteSize === 32 ? 'byte_array_to_uint256_value' : 'byte_array_to_felt_value';
    const importedFunc = this.requireImport('warplib.dynamic_arrays_util', funcName);
    return importedFunc;
  }
}

function calcOffset(indexLocation: string, offsetLocation: string, substractor: string) {
  if (indexLocation === substractor) return offsetLocation;
  if (offsetLocation === substractor) return indexLocation;
  if (substractor === '0') return `${indexLocation} + ${offsetLocation}`;
  return `${indexLocation} + ${offsetLocation} - ${substractor}`;
}
