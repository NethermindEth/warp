import { ArrayType, BytesType, SourceUnit, StringType, TypeNode } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { getElementType, getPackedByteSize, isDynamicArray } from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { delegateBasedOnType, mul } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';
import { AbiBase } from './base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * Given any data type produces the same output of solidty abi.encodePacked
 * in the form of an array of felts where each element represents a byte
 */
export class AbiEncodePacked extends AbiBase {
  protected override functionName = 'abi_encode_packed';
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
        encodings.push(this.generateEncodingCode(type, 'bytes_index', `param${index}`));
        return [params, encodings];
      },
      [new Array<{ name: string; type: string }>(), new Array<string>()],
    );

    const cairoParams = params.map((p) => `${p.name} : ${p.type}`).join(', ');
    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (result_ptr : felt):`,
      `  alloc_locals`,
      `  let bytes_index : felt = 0`,
      `  let (bytes_array : felt*) = alloc()`,
      ...encodings,
      `  let (max_length256) = felt_to_uint256(bytes_index)`,
      `  let (mem_ptr) = wm_new(max_length256, ${uint256(1)})`,
      `  felt_array_to_warp_memory_array(0, bytes_array, 0, mem_ptr, bytes_index)`,
      `  return (mem_ptr)`,
      `end`,
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

  public override getOrCreateEncoding(type: TypeNode): string {
    const unexpectedType = () => {
      throw new TranspileFailedError(`Encoding ${printTypeNode(type)} is not supported`);
    };

    return delegateBasedOnType<string>(
      type,
      (type) => this.createArrayInlineEncoding(type),
      (type) => this.createArrayInlineEncoding(type),
      unexpectedType,
      unexpectedType,
      (type) => this.createValueTypeHeadEncoding(getPackedByteSize(type)),
    );
  }

  private generateEncodingCode(type: TypeNode, newIndexVar: string, varToEncode: string): string {
    const funcName = this.getOrCreateEncoding(type);
    if (isDynamicArray(type)) {
      this.requireImport('warplib.memory', 'wm_dyn_array_length');
      this.requireImport('warplib.maths.utils', 'narrow_safe');
      return [
        `let (length256) = wm_dyn_array_length(${varToEncode})`,
        `let (length) = narrow_safe(length256)`,
        `let (${newIndexVar}) = ${funcName}(bytes_index, bytes_array, 0, length, ${varToEncode})`,
      ].join('\n');
    }
    if (type instanceof ArrayType) {
      return `let (${newIndexVar}) = ${funcName}(bytes_index, bytes_array, 0, ${type.size}, ${varToEncode})`;
    }

    // This will never execute
    if (type instanceof StringType || type instanceof BytesType) {
      this.requireImport('warplib.memory', 'wm_dyn_array_length');
      this.requireImport('warplib.maths.utils', 'narrow_safe');
      return [
        `let (length256) = wm_dyn_array_length(${varToEncode})`,
        `let (length) = narrow_safe(length256)`,
        `${funcName}(bytes_index, bytes_index + length, bytes_array, 0, length, ${varToEncode} + 2)`,
        `let ${newIndexVar} = bytes_index + length`,
      ].join('\n');
    }

    // Type is value type
    const packedByteSize = getPackedByteSize(type, this.ast.compilerVersion);
    const args = ['bytes_index', 'bytes_array', '0', varToEncode];
    if (packedByteSize < 32) args.push(`${packedByteSize}`);

    return [
      `${funcName}(${args.join(',')})`,
      `let ${newIndexVar} = bytes_index +  ${packedByteSize}`,
    ].join('\n');
  }

  private createArrayInlineEncoding(type: ArrayType | BytesType | StringType): string {
    const key = type.pp();
    const exisiting = this.auxiliarGeneratedFunctions.get(key);
    if (exisiting !== undefined) {
      return exisiting.name;
    }

    const elementT = getElementType(type);
    const cairoElementT = CairoType.fromSol(elementT, this.ast, TypeConversionContext.Ref);

    // Obtaining the location differs from static and dynamic arrays
    const elementTSize256 = uint256(cairoElementT.width);
    const getElemLoc = isDynamicArray(type)
      ? [
          `let (mem_index256) = felt_to_uint256(mem_index)`,
          `let (elem_loc : felt) = wm_index_dyn(mem_ptr, mem_index256, ${elementTSize256})`,
        ].join('\n')
      : `let elem_loc : felt = mem_ptr + ${mul('mem_index', cairoElementT.width)}`;

    const readFunc = this.memoryRead.getOrCreate(cairoElementT);
    const readCode = `let (elem) = ${readFunc}(elem_loc)`;

    const encodingCode = this.generateEncodingCode(elementT, 'new_bytes_index', 'elem');

    const name = `${this.functionName}_inline_array${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${name}${IMPLICITS}(`,
      `  bytes_index : felt,`,
      `  bytes_array : felt*,`,
      `  mem_index : felt,`,
      `  mem_length : felt,`,
      `  mem_ptr : felt,`,
      `) -> (final_bytes_index : felt):`,
      `  alloc_locals`,
      `  if mem_index == mem_length:`,
      `     return (final_bytes_index=bytes_index)`,
      `  end`,
      `  ${getElemLoc}`,
      `  ${readCode}`,
      `  ${encodingCode}`,
      `  return ${name}(`,
      `     new_bytes_index,`,
      `     bytes_array,`,
      `     mem_index + 1,`,
      `     mem_length,`,
      `     mem_ptr`,
      `  )`,
      `end`,
    ].join('\n');

    if (isDynamicArray(type)) {
      this.requireImport('warplib.memory', 'wm_index_dyn');
      this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    }

    this.auxiliarGeneratedFunctions.set(key, { name, code });
    return name;
  }

  private createStringOrBytesHeadEncoding(): string {
    const funcName = 'bytes_to_felt_dynamic_array_inline';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  private createValueTypeHeadEncoding(size: number | bigint): string {
    const funcName =
      size === 32 ? 'fixed_bytes256_to_felt_dynamic_array' : `fixed_bytes_to_felt_dynamic_array`;
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }
}
