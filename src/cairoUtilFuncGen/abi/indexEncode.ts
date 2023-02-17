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
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, MemoryLocation, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
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
import { delegateBasedOnType, mul } from '../base';
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

  public getOrCreate(types: TypeNode[]): string {
    const key = types.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [params, encodings] = types.reduce(
      ([params, encodings], type, index) => {
        const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref);
        params.push({ name: `param${index}`, type: cairoType.toString() });
        encodings.push(
          // padding is not required for strings and bytes
          this.generateEncodingCode(type, 'bytes_index', `param${index}`, false),
        );
        return [params, encodings];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt){`,
      `  `,
      `  let bytes_index : felt = 0;`,
      `  let (bytes_array : felt*) = alloc();`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_index);`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)});`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index);`,
      `  return (mem_ptr,);`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.alloc', 'alloc');
    this.requireImport('starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin');
    this.requireImport('starkware.cairo.common.uint256', 'u256');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.dynamic_arrays_util', 'felt_array_to_warp_memory_array');

    const cairoFunc = { name: funcName, code: code };
    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  /**
   * Given a type generate a function that abi-encodes it
   * @param type type to encode
   * @returns the name of the generated function
   */
  public getOrCreateEncoding(type: TypeNode, padding = true): string {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported yet`);
    };

    return delegateBasedOnType<string>(
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
  ): string {
    const funcName = this.getOrCreateEncoding(type, padding);
    if (isDynamicallySized(type, this.ast.inference) || isStruct(type)) {
      return [
        `let (${newIndexVar}) = ${funcName}(`,
        `  bytes_index,`,
        `  bytes_array,`,
        `  ${varToEncode}`,
        `);`,
      ].join('\n');
    }

    // Static array with known compile time size
    if (type instanceof ArrayType) {
      assert(type.size !== undefined);
      return [
        `let (${newIndexVar}) = ${funcName}(`,
        `  bytes_index,`,
        `  bytes_array,`,
        `  0,`,
        `  ${type.size},`,
        `  ${varToEncode},`,
        `);`,
      ].join('\n');
    }

    // Is value type
    const size = getPackedByteSize(type, this.ast.inference);
    const instructions: string[] = [];
    // packed size of addresses is 32 bytes, but they are treated as felts,
    // so they should be converted to u256 accordingly
    if (size < 32 || isAddressType(type)) {
      this.requireImport(`warplib.maths.utils`, 'felt_to_uint256');
      instructions.push(`let (${varToEncode}256) = felt_to_uint256(${varToEncode});`);
      varToEncode = `${varToEncode}256`;
    }
    instructions.push(
      ...[
        `${funcName}(bytes_index, bytes_array, 0, ${varToEncode});`,
        `let ${newIndexVar} = bytes_index + 32;`,
      ],
    );
    return instructions.join('\n');
  }

  private createDynamicArrayHeadEncoding(type: ArrayType): string {
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const tailEncoding = this.createDynamicArrayTailEncoding(type);
    const name = `${this.functionName}_head_dynamic_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index: felt,`,
      `  bytes_array: felt*,`,
      `  mem_ptr : felt`,
      `) -> (final_bytes_index : felt){`,
      `  `,
      `  let (length256) = wm_dyn_array_length(mem_ptr);`,
      `  let (length) = narrow_safe(length256);`,
      `  // Storing the element values encoding`,
      `  let (new_index) = ${tailEncoding}(`,
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

    this.requireImport('warplib.memory', 'wm_dyn_array_length');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('warplib.maths.utils', 'narrow_safe');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createDynamicArrayTailEncoding(type: ArrayType): string {
    const key = 'tail ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const elementT = getElementType(type);
    const elemntTSize = CairoType.fromSol(elementT, this.ast).width;

    const readElement = this.readMemory(elementT, 'elem_loc');
    const headEncodingCode = this.generateEncodingCode(elementT, 'bytes_index', 'elem');
    const name = `${this.functionName}_tail_dynamic_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  index : felt,`,
      `  length : felt,`,
      `  mem_ptr : felt`,
      `) -> (final_index : felt){`,
      `  `,
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

    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStaticArrayHeadEncoding(type: ArrayType): string {
    assert(type.size !== undefined);
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const inlineEncoding = this.createArrayInlineEncoding(type);

    const name = `${this.functionName}_head_static_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  `,
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

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createArrayInlineEncoding(type: ArrayType) {
    const key = 'inline ' + removeSizeInfo(type);
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const elementTWidth = CairoType.fromSol(type.elementT, this.ast).width;

    const readElement = this.readMemory(type.elementT, 'elem_loc');

    const headEncodingCode = this.generateEncodingCode(type.elementT, 'bytes_index', 'elem');

    const name = `${this.functionName}_inline_array_spl${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_index : felt,`,
      `  mem_length : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  `,
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

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStructHeadEncoding(type: UserDefinedType, def: StructDefinition) {
    const key = 'struct head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const inlineEncoding = this.createStructInlineEncoding(type, def);

    const name = `${this.functionName}_head_spl_${def.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  `,
      `  // Storing the data values encoding`,
      `  let (bytes_index) = ${inlineEncoding}(`,
      `    bytes_index,`,
      `    bytes_array,`,
      `    mem_ptr`,
      `);`,
      `  return (bytes_index,);`,
      `}`,
    ].join('\n');

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStructInlineEncoding(type: UserDefinedType, def: StructDefinition) {
    const key = 'struct inline ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const instructions = def.vMembers.map((member, index) => {
      const type = generalizeType(safeGetNodeType(member, this.ast.inference))[0];
      const elemWidth = CairoType.fromSol(type, this.ast).width;
      const readFunc = this.readMemory(type, 'mem_ptr');
      const encoding = this.generateEncodingCode(type, 'bytes_index', `elem${index}`);
      return [
        `// Encoding member ${member.name}`,
        `let (elem${index}) = ${readFunc};`,
        `${encoding}`,
        `let mem_ptr = mem_ptr + ${elemWidth};`,
      ].join('\n');
    });

    const name = `${this.functionName}_inline_struct_spl_${def.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt){`,
      `  `,
      ...instructions,
      `  return (bytes_index,);`,
      `}`,
    ].join('\n');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStringOrBytesHeadEncoding(): string {
    const funcName = 'bytes_to_felt_dynamic_array_spl';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  private createStringOrBytesHeadEncodingWithoutPadding(): string {
    const funcName = 'bytes_to_felt_dynamic_array_spl_without_padding';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  private createValueTypeHeadEncoding(): string {
    const funcName = 'fixed_bytes256_to_felt_dynamic_array_spl';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  protected readMemory(type: TypeNode, arg: string) {
    const cairoType = CairoType.fromSol(type, this.ast);
    const funcName = this.memoryRead.getOrCreate(cairoType);
    const args =
      cairoType instanceof MemoryLocation
        ? [arg, isDynamicArray(type) ? uint256(2) : uint256(0)]
        : [arg];
    return `${funcName}(${args.join(',')})`;
  }
}
