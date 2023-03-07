import assert from 'assert';
import {
  ArrayType,
  generalizeType,
  SourceUnit,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, MemoryLocation, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import {
  ALLOC,
  BITWISE_BUILTIN,
  DYNAMIC_ARRAYS_UTIL,
  FELT_ARRAY_TO_WARP_MEMORY_ARRAY,
  FELT_TO_UINT256,
  NARROW_SAFE,
  UINT256,
  WM_DYN_ARRAY_LENGTH,
  WM_INDEX_DYN,
  WM_NEW,
} from '../../utils/importPaths';
import {
  getElementType,
  getPackedByteSize,
  isAddressType,
  isDynamicallySized,
  isDynamicArray,
  isStruct,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { delegateBasedOnType, GeneratedFunctionInfo, mul } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';
import { AbiBase, removeSizeInfo } from './base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * It is a special class used for encoding of indexed arguments in events.
 * More info at:
   https://docs.soliditylang.org/en/v0.8.14/abi-spec.html#encoding-of-indexed-event-parameters
 */
export class IndexEncode extends AbiBase {
  protected override functionName = 'index_encode';
  protected memoryRead: MemoryReadGen;

  constructor(memoryRead: MemoryReadGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
    this.memoryRead = memoryRead;
  }

  public getOrCreate(types: TypeNode[]): GeneratedFunctionInfo {
    const [params, encodings, functionsCalled] = types.reduce(
      ([params, encodings, functionsCalled], type, index) => {
        const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });
        const [paramEncoding, paramFuncCalls] = this.generateEncodingCode(
          type,
          'bytes_index',
          `param${index}`,
          false,
        );
        encodings.push(paramEncoding);
        return [params, encodings, functionsCalled.concat(paramFuncCalls)];
      },
      [
        new Array<{ name: string; type: string }>(),
        new Array<string>(),
        new Array<CairoFunctionDefinition>(),
      ],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt){`,
      `  alloc_locals;`,
      `  let bytes_index : felt = 0;`,
      `  let (bytes_array : felt*) = alloc();`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_index);`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)});`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index);`,
      `  return (mem_ptr,);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport(...ALLOC),
      this.requireImport(...BITWISE_BUILTIN),
      this.requireImport(...UINT256),
      this.requireImport(...FELT_TO_UINT256),
      this.requireImport(...WM_NEW),
      this.requireImport(...FELT_ARRAY_TO_WARP_MEMORY_ARRAY),
    ];

    const cairoFunc = {
      name: funcName,
      code: code,
      functionsCalled: [...importedFuncs, ...functionsCalled],
    };
    return cairoFunc;
  }

  /**
   * Given a type generate a function that abi-encodes it
   * @param type type to encode
   * @returns the name of the generated function
   */
  public getOrCreateEncoding(type: TypeNode, padding = true): CairoFunctionDefinition {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported yet`);
    };

    return delegateBasedOnType<CairoFunctionDefinition>(
      type,
      (type) =>
        type instanceof ArrayType
          ? this.createDynamicArrayHeadEncoding(type)
          : padding
          ? this.createStringOrBytesHeadEncoding()
          : this.createStringOrBytesHeadEncodingWithoutPadding(),
      (type) =>
        isDynamicallySized(type, this.ast.inference)
          ? this.createStaticArrayHeadEncoding(type)
          : this.createArrayInlineEncoding(type),
      (type, def) =>
        isDynamicallySized(type, this.ast.inference)
          ? this.createStructHeadEncoding(type, def)
          : this.createStructInlineEncoding(type, def),
      unexpectedType,
      () => this.createValueTypeHeadEncoding(),
    );
  }

  /**
   * Given a type it generates the function to encodes it, as well as all other
   * instructions required to use it.
   * @param type type to encode
   * @param newIndexVar cairo var where the updated index should be stored
   * @param varToEncode variable that holds the values to encode
   * @returns instructions to encode `varToEncode`
   */
  public generateEncodingCode(
    type: TypeNode,
    newIndexVar: string,
    varToEncode: string,
    padding = true,
  ): [string, CairoFunctionDefinition[]] {
    const func = this.getOrCreateEncoding(type, padding);
    if (isDynamicallySized(type, this.ast.inference) || isStruct(type)) {
      return [
        [
          `let (${newIndexVar}) = ${func.name}(`,
          `  bytes_index,`,
          `  bytes_array,`,
          `  ${varToEncode}`,
          `);`,
        ].join('\n'),
        [func],
      ];
    }

    // Static array with known compile time size
    if (type instanceof ArrayType) {
      assert(type.size !== undefined);
      return [
        [
          `let (${newIndexVar}) = ${func.name}(`,
          `  bytes_index,`,
          `  bytes_array,`,
          `  0,`,
          `  ${type.size},`,
          `  ${varToEncode},`,
          `);`,
        ].join('\n'),
        [func],
      ];
    }

    // Is value type
    const size = getPackedByteSize(type, this.ast.inference);
    const instructions: string[] = [];
    const importedFunc = [];
    // packed size of addresses is 32 bytes, but they are treated as felts,
    // so they should be converted to Uint256 accordingly
    if (size < 32 || isAddressType(type)) {
      instructions.push(`let (${varToEncode}256) = felt_to_uint256(${varToEncode});`);
      importedFunc.push(this.requireImport(...FELT_TO_UINT256));
      varToEncode = `${varToEncode}256`;
    }
    instructions.push(
      ...[
        `${func.name}(bytes_index, bytes_array, 0, ${varToEncode});`,
        `let ${newIndexVar} = bytes_index + 32;`,
      ],
    );
    return [instructions.join('\n'), importedFunc];
  }

  private createDynamicArrayHeadEncoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const tailEncoding = this.createDynamicArrayTailEncoding(type);
    const name = `${this.functionName}_head_dynamic_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index: felt,`,
      `  bytes_array: felt*,`,
      `  mem_ptr : felt`,
      `) -> (final_bytes_index : felt){`,
      `  alloc_locals;`,
      `  let (length256) = wm_dyn_array_length(mem_ptr);`,
      `  let (length) = narrow_safe(length256);`,
      `  // Storing the element values encoding`,
      `  let (new_index) = ${tailEncoding.name}(`,
      `    bytes_index,`,
      `    bytes_array,`,
      `    0,`,
      `    length,`,
      `    mem_ptr`,
      `  );`,
      `  return (`,
      `    final_bytes_index=new_index,`,
      `  );`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport(...WM_DYN_ARRAY_LENGTH),
      this.requireImport(...FELT_TO_UINT256),
      this.requireImport(...NARROW_SAFE),
    ];

    const funcInfo = { name, code, functionsCalled: [...importedFuncs, tailEncoding] };
    const auxFunc = this.createAuxiliarGeneratedFunction(funcInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createDynamicArrayTailEncoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'tail ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementT = getElementType(type);
    const elemntTSize = CairoType.fromSol(elementT, this.ast).width;

    const [readElement, readFunc] = this.readMemory(elementT, 'elem_loc');
    const [headEncodingCode, functionsCalled] = this.generateEncodingCode(
      elementT,
      'bytes_index',
      'elem',
    );
    const name = `${this.functionName}_tail_dynamic_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  index : felt,`,
      `  length : felt,`,
      `  mem_ptr : felt`,
      `) -> (final_index : felt){`,
      `  alloc_locals;`,
      `  if (index == length){`,
      `     return (final_index=bytes_index);`,
      `  }`,
      `  let (index256) = felt_to_uint256(index);`,
      `  let (elem_loc) = wm_index_dyn(mem_ptr, index256, ${uint256(elemntTSize)});`,
      `  let (elem) = ${readElement};`,
      `  ${headEncodingCode}`,
      `  return ${name}(bytes_index, bytes_array, index + 1, length, mem_ptr);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport(...WM_INDEX_DYN),
      this.requireImport(...FELT_TO_UINT256),
    ];

    const funcInfo = {
      name,
      code,
      functionsCalled: [...importedFuncs, ...functionsCalled, readFunc],
    };
    const auxFunc = this.createAuxiliarGeneratedFunction(funcInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStaticArrayHeadEncoding(type: ArrayType): CairoFunctionDefinition {
    assert(type.size !== undefined);
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const inlineEncoding = this.createArrayInlineEncoding(type);

    const name = `${this.functionName}_head_static_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  alloc_locals;`,
      `  let length = ${type.size};`,
      `  // Storing the data values encoding`,
      `  let (bytes_index) = ${inlineEncoding}(`,
      `    bytes_index,`,
      `    bytes_array,`,
      `    0,`,
      `    length,`,
      `    mem_ptr`,
      `  );`,
      `  return (`,
      `    final_bytes_index=new_bytes_index,`,
      `  );`,
      `}`,
    ].join('\n');

    const importedFunc = this.requireImport(...FELT_TO_UINT256);

    const funcInfo = { name, code, functionsCalled: [importedFunc] };
    const auxFunc = this.createAuxiliarGeneratedFunction(funcInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createArrayInlineEncoding(type: ArrayType): CairoFunctionDefinition {
    const key = 'inline ' + removeSizeInfo(type);
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const elementTWidth = CairoType.fromSol(type.elementT, this.ast).width;

    const [readElement, readFunc] = this.readMemory(type.elementT, 'elem_loc');

    const [headEncodingCode, functionsCalled] = this.generateEncodingCode(
      type.elementT,
      'bytes_index',
      'elem',
    );

    const name = `${this.functionName}_inline_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_index : felt,`,
      `  mem_length : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  alloc_locals;`,
      `  if (mem_index == mem_length){`,
      `     return (final_bytes_index=bytes_index);`,
      `  }`,
      `  let elem_loc = mem_ptr + ${mul('mem_index', elementTWidth)};`,
      `  let (elem) = ${readElement};`,
      `  ${headEncodingCode}`,
      `  return ${name}(`,
      `     bytes_index,`,
      `     bytes_array,`,
      `     mem_index + 1,`,
      `     mem_length,`,
      `     mem_ptr`,
      `  );`,
      `}`,
    ].join('\n');

    const funcInfo = { name, code, functionsCalled: [...functionsCalled, readFunc] };

    const auxFunc = this.createAuxiliarGeneratedFunction(funcInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStructHeadEncoding(
    type: UserDefinedType,
    def: StructDefinition,
  ): CairoFunctionDefinition {
    const key = 'struct head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const inlineEncoding = this.createStructInlineEncoding(type, def);

    const name = `${this.functionName}_head_spl_${def.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  alloc_locals;`,
      `  // Storing the data values encoding`,
      `  let (bytes_index) = ${inlineEncoding}(`,
      `    bytes_index,`,
      `    bytes_array,`,
      `    mem_ptr`,
      `);`,
      `  return (bytes_index,);`,
      `}`,
    ].join('\n');

    const importedFunction = this.requireImport(...FELT_TO_UINT256);

    const funcInfo = { name, code, functionsCalled: [importedFunction, inlineEncoding] };
    const auxFunc = this.createAuxiliarGeneratedFunction(funcInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);

    return auxFunc;
  }

  private createStructInlineEncoding(
    type: UserDefinedType,
    def: StructDefinition,
  ): CairoFunctionDefinition {
    const key = 'struct inline ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing;

    const encodingInfo: [string, CairoFunctionDefinition[]][] = def.vMembers.map(
      (member, index) => {
        const type = generalizeType(safeGetNodeType(member, this.ast.inference))[0];
        const elemWidth = CairoType.fromSol(type, this.ast).width;
        const [readElement, readFunc] = this.readMemory(type, 'mem_ptr');
        const [encoding, functionsCalled] = this.generateEncodingCode(
          type,
          'bytes_index',
          `elem${index}`,
        );
        return [
          [
            `// Encoding member ${member.name}`,
            `let (elem${index}) = ${readElement};`,
            `${encoding}`,
            `let mem_ptr = mem_ptr + ${elemWidth};`,
          ].join('\n'),
          [...functionsCalled, readFunc],
        ];
      },
    );

    const [instructions, functionsCalled] = encodingInfo.reduce(
      ([instructions, functionsCalled], [currentInstruction, currentFuncs]) => [
        [...instructions, currentInstruction],
        [...functionsCalled, ...currentFuncs],
      ],
      [new Array<string>(), new Array<CairoFunctionDefinition>()],
    );

    const name = `${this.functionName}_inline_struct_spl_${def.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  alloc_locals;`,
      ...instructions,
      `  return (bytes_index,);`,
      `}`,
    ].join('\n');

    const funcInfo = { name, code, functionsCalled };
    const auxFunc = this.createAuxiliarGeneratedFunction(funcInfo);

    this.auxiliarGeneratedFunctions.set(key, auxFunc);
    return auxFunc;
  }

  private createStringOrBytesHeadEncoding(): CairoImportFunctionDefinition {
    const funcName = 'bytes_to_felt_dynamic_array_spl';
    return this.requireImport(DYNAMIC_ARRAYS_UTIL, funcName);
  }

  private createStringOrBytesHeadEncodingWithoutPadding(): CairoImportFunctionDefinition {
    const funcName = 'bytes_to_felt_dynamic_array_spl_without_padding';
    return this.requireImport(DYNAMIC_ARRAYS_UTIL, funcName);
  }

  private createValueTypeHeadEncoding(): CairoImportFunctionDefinition {
    const funcName = 'fixed_bytes256_to_felt_dynamic_array_spl';
    return this.requireImport(DYNAMIC_ARRAYS_UTIL, funcName);
  }

  protected readMemory(type: TypeNode, arg: string): [string, CairoFunctionDefinition] {
    const func = this.memoryRead.getOrCreateFuncDef(type);
    const cairoType = CairoType.fromSol(type, this.ast);
    const args =
      cairoType instanceof MemoryLocation
        ? [arg, isDynamicArray(type) ? uint256(2) : uint256(0)]
        : [arg];
    return [`${func.name}(${args.join(',')})`, func];
  }
}
