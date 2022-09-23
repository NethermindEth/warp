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
  getByteSize,
  getElementType,
  getPackedByteSize,
  isDynamicallySized,
  isDynamicArray,
  isStruct,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { delegateBasedOnType, mul } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';
import { AbiBase } from './base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * Given any data type produces the same output of solidty abi.encode
 * in the form of an array of felts where each element represents a byte
 */
export class AbiEncode extends AbiBase {
  protected override functionName = 'abi_encode';
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
          this.generateEncodingCode(type, 'bytes_index', 'bytes_offset', '0', `param${index}`),
        );
        return [params, encodings];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const initialOffset = types.reduce(
      (pv, cv) => pv + BigInt(getByteSize(cv, this.ast.compilerVersion)),
      0n,
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt){`,
      `  alloc_locals;`,
      `  let bytes_index : felt = 0;`,
      `  let bytes_offset : felt = ${initialOffset};`,
      `  let (bytes_array : felt*) = alloc();`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_offset);`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)});`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_offset);`,
      `  return (mem_ptr,);`,
      `}`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');
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
  public getOrCreateEncoding(type: TypeNode): string {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported yet`);
    };

    return delegateBasedOnType<string>(
      type,
      (type) =>
        type instanceof ArrayType
          ? this.createDynamicArrayHeadEncoding(type)
          : this.createStringOrBytesHeadEncoding(),
      (type) =>
        isDynamicallySized(type, this.ast.compilerVersion)
          ? this.createStaticArrayHeadEncoding(type)
          : this.createArrayInlineEncoding(type),
      (type, def) =>
        isDynamicallySized(type, this.ast.compilerVersion)
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
   * @param newOffsetVar cairo var where the updated offset should be stored
   * @param elementOffset used to calculate the relative offset of dynamically sized types
   * @param varToEncode variable that holds the values to encode
   * @returns instructions to encode `varToEncode`
   */
  public generateEncodingCode(
    type: TypeNode,
    newIndexVar: string,
    newOffsetVar: string,
    elementOffset: string,
    varToEncode: string,
  ): string {
    const funcName = this.getOrCreateEncoding(type);
    if (isDynamicallySized(type, this.ast.compilerVersion) || isStruct(type)) {
      return [
        `let (${newIndexVar}, ${newOffsetVar}) = ${funcName}(`,
        `  bytes_index,`,
        `  bytes_offset,`,
        `  bytes_array,`,
        `  ${elementOffset},`,
        `  ${varToEncode}`,
        `);`,
      ].join('\n');
    }

    // Static array with known compile time size
    if (type instanceof ArrayType) {
      assert(type.size !== undefined);
      return [
        `let (${newIndexVar}, ${newOffsetVar}) = ${funcName}(`,
        `  bytes_index,`,
        `  bytes_offset,`,
        `  bytes_array,`,
        `  ${elementOffset},`,
        `  0,`,
        `  ${type.size},`,
        `  ${varToEncode},`,
        `);`,
      ].join('\n');
    }

    // Is value type
    const size = getPackedByteSize(type, this.ast.compilerVersion);
    const instructions: string[] = [];
    if (size < 32) {
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
    if (newOffsetVar !== 'bytes_offset') {
      instructions.push(`let ${newOffsetVar} = bytes_offset;`);
    }
    return instructions.join('\n');
  }

  private createDynamicArrayHeadEncoding(type: ArrayType): string {
    const key = 'head ' + type.pp();
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const elementT = getElementType(type);
    const elementByteSize = getByteSize(elementT, this.ast.compilerVersion);

    const tailEncoding = this.createDynamicArrayTailEncoding(type);
    const name = `${this.functionName}_head_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  element_offset : felt,`,
      `  mem_ptr : felt`,
      `) -> (final_bytes_index : felt, final_bytes_offset : felt){`,
      `  alloc_locals;`,
      `  // Storing pointer to data`,
      `  let (bytes_offset256) = felt_to_uint256(bytes_offset - element_offset);`,
      `  ${this.createValueTypeHeadEncoding()}(bytes_index, bytes_array, 0, bytes_offset256);`,
      `  let new_index = bytes_index + 32;`,
      `  // Storing the length`,
      `  let (length256) = wm_dyn_array_length(mem_ptr);`,
      `  ${this.createValueTypeHeadEncoding()}(bytes_offset, bytes_array, 0, length256);`,
      `  let bytes_offset = bytes_offset + 32;`,
      `  // Storing the data`,
      `  let (length) = narrow_safe(length256);`,
      `  let bytes_offset_offset = bytes_offset + ${mul('length', elementByteSize)};`,
      `  let (extended_offset) = ${tailEncoding}(`,
      `    bytes_offset,`,
      `    bytes_offset_offset,`,
      `    bytes_array,`,
      `    bytes_offset,`,
      `    0,`,
      `    length,`,
      `    mem_ptr`,
      `  );`,
      `  return (`,
      `    final_bytes_index=new_index,`,
      `    final_bytes_offset=extended_offset`,
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
    const headEncodingCode = this.generateEncodingCode(
      elementT,
      'new_bytes_index',
      'new_bytes_offset',
      'element_offset',
      'elem',
    );
    const name = `${this.functionName}_tail_dynamic_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  element_offset : felt,`,
      `  index : felt,`,
      `  length : felt,`,
      `  mem_ptr : felt`,
      `) -> (final_offset : felt){`,
      `  alloc_locals;`,
      `  if (index == length){`,
      `     return (final_offset=bytes_offset);`,
      `  }`,
      `  let (index256) = felt_to_uint256(index);`,
      `  let (elem_loc) = wm_index_dyn(mem_ptr, index256, ${uint256(elemntTSize)});`,
      `  let (elem) = ${readElement};`,
      `  ${headEncodingCode}`,
      `  return ${name}(new_bytes_index, new_bytes_offset, bytes_array, element_offset, index + 1, length, mem_ptr);`,
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

    const elementT = getElementType(type);
    const elementByteSize = getByteSize(elementT, this.ast.compilerVersion);

    const inlineEncoding = this.createArrayInlineEncoding(type);

    const name = `${this.functionName}_head_static_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  element_offset : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt, final_bytes_offset : felt){`,
      `  alloc_locals;`,
      `  // Storing pointer to data`,
      `  let (bytes_offset256) = felt_to_uint256(bytes_offset - element_offset);`,
      `  ${this.createValueTypeHeadEncoding()}(bytes_index, bytes_array, 0, bytes_offset256);`,
      `  let new_bytes_index = bytes_index + 32;`,
      `  // Storing the data`,
      `  let length = ${type.size};`,
      `  let bytes_offset_offset = bytes_offset + ${mul('length', elementByteSize)};`,
      `  let (_, extended_offset) = ${inlineEncoding}(`,
      `    bytes_offset,`,
      `    bytes_offset_offset,`,
      `    bytes_array,`,
      `    bytes_offset,`,
      `    0,`,
      `    length,`,
      `    mem_ptr`,
      `  );`,
      `  return (`,
      `    final_bytes_index=new_bytes_index,`,
      `    final_bytes_offset=extended_offset`,
      `  );`,
      `}`,
    ].join('\n');

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createArrayInlineEncoding(type: ArrayType) {
    let key = 'inline ' + type.pp();
    // Modifiy key to generate same function for diferent size (but same element type)
    // static arrays
    if (type.size !== undefined) {
      const reversedKey = key.split('').reverse().join('');
      // swapping '[<num>]' for '[]' but since string is reversed we are swapping ']<num>[' for ']['
      const parsedKey = reversedKey.replace(/\][0-9]+\[/, '][');
      key = parsedKey.split('').reverse().join('');
    }
    const existing = this.auxiliarGeneratedFunctions.get(key);
    if (existing !== undefined) return existing.name;

    const elementTWidth = CairoType.fromSol(type.elementT, this.ast).width;

    const readElement = this.readMemory(type.elementT, 'elem_loc');

    const headEncodingCode = this.generateEncodingCode(
      type.elementT,
      'new_bytes_index',
      'new_bytes_offset',
      'element_offset',
      'elem',
    );

    const name = `${this.functionName}_inline_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  element_offset : felt,`,
      `  mem_index : felt,`,
      `  mem_length : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt, final_bytes_offset : felt){`,
      `  alloc_locals;`,
      `  if (mem_index == mem_length){`,
      `     return (final_bytes_index=bytes_index, final_bytes_offset=bytes_offset);`,
      `  }`,
      `  let elem_loc = mem_ptr + ${mul('mem_index', elementTWidth)};`,
      `  let (elem) = ${readElement};`,
      `  ${headEncodingCode}`,
      `  return ${name}(`,
      `     new_bytes_index,`,
      `     new_bytes_offset,`,
      `     bytes_array,`,
      `     element_offset,`,
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
    // Get the size of all it's members
    const typeByteSize = def.vMembers.reduce(
      (sum, varDecl) =>
        sum +
        BigInt(
          getByteSize(
            generalizeType(safeGetNodeType(varDecl, this.ast.compilerVersion))[0],
            this.ast.compilerVersion,
          ),
        ),
      0n,
    );

    const name = `${this.functionName}_head_${def.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  element_offset : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt, final_bytes_offset : felt){`,
      `  alloc_locals;`,
      `  // Storing pointer to data`,
      `  let (bytes_offset256) = felt_to_uint256(bytes_offset - element_offset);`,
      `  ${this.createValueTypeHeadEncoding()}(bytes_index, bytes_array, 0, bytes_offset256);`,
      `  let new_bytes_index = bytes_index + 32;`,
      `  // Storing the data`,
      `  let bytes_offset_offset = bytes_offset + ${typeByteSize};`,
      `  let (_, new_bytes_offset) = ${inlineEncoding}(`,
      `    bytes_offset,`,
      `    bytes_offset_offset,`,
      `    bytes_array,`,
      `    bytes_offset,`,
      `    mem_ptr`,
      `);`,
      `  return (new_bytes_index, new_bytes_offset);`,
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
      const type = generalizeType(safeGetNodeType(member, this.ast.compilerVersion))[0];
      const elemWidth = CairoType.fromSol(type, this.ast).width;
      const readFunc = this.readMemory(type, 'mem_ptr');
      const encoding = this.generateEncodingCode(
        type,
        'bytes_index',
        'bytes_offset',
        'element_offset',
        `elem${index}`,
      );
      return [
        `// Encoding member ${member.name}`,
        `let (elem${index}) = ${readFunc};`,
        `${encoding}`,
        `let mem_ptr = mem_ptr + ${elemWidth};`,
      ].join('\n');
    });

    const name = `${this.functionName}_inline_struct_${def.name}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_offset : felt,`,
      `  bytes_array : felt*,`,
      `  element_offset : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt, final_bytes_offset : felt){`,
      `  alloc_locals;`,
      ...instructions,
      `  return (bytes_index, bytes_offset);`,
      `}`,
    ].join('\n');

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStringOrBytesHeadEncoding(): string {
    const funcName = 'bytes_to_felt_dynamic_array';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  private createValueTypeHeadEncoding(): string {
    const funcName = 'fixed_bytes256_to_felt_dynamic_array';
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
