import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import {
  getElementType,
  getTypeByteSize,
  isDynamicArray,
  isValueType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';
import { MemoryReadGen } from '../memory/memoryRead';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

/**
 * Given any data type produces the same output of solidty abi.encodePacked
 * in the form of an array of felts where each element represents a byte
 */
export class AbiEncodePacked extends StringIndexedFuncGen {
  protected functionName = 'abi_encode_packed';
  protected auxiliarGeneratedFunctions = new Map<string, CairoFunction>();

  constructor(protected memoryRead: MemoryReadGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  getGeneratedCode(): string {
    return [...this.auxiliarGeneratedFunctions.values(), ...this.generatedFunctions.values()]
      .map((func) => func.code)
      .join('\n\n');
  }

  gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
    const exprTypes = expressions.map(
      (expr) => generalizeType(getNodeType(expr, this.ast.compilerVersion))[0],
    );
    const functionName = this.getOrCreate(exprTypes);

    const functionStub = createCairoFunctionStub(
      functionName,
      exprTypes.map((exprT, index) =>
        isValueType(exprT)
          ? [`param${index}`, typeNameFromTypeNode(exprT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(exprT, this.ast), DataLocation.Memory],
      ),
      [['result', createBytesTypeName(this.ast), DataLocation.Memory]],
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );

    return createCallToFunction(functionStub, expressions, this.ast);
  }

  getOrCreate(typesToEncode: TypeNode[]): string {
    const key = typesToEncode.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const memLoc = 'bytes_ptr';
    const currIndex = 'index';
    const updateIndex = (size: number | string) => `let ${currIndex} = index + ${size}`;

    const pararmeters: { name: string; type: string }[] = [];
    const encodingCode: string[] = [];

    typesToEncode.forEach((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.Ref);
      const prefix = `param${index}`;
      const sizeVar = isValueType(type) ? `size_${index}` : `length_${index}`;
      pararmeters.push({ name: prefix, type: cairoType.toString() });
      encodingCode.push(
        ...[
          this.generateTypeEncoding(type, memLoc, currIndex, prefix, sizeVar),
          updateIndex(`size_${index}`),
        ],
      );
    });

    const allSizes = typesToEncode
      .map((type, index) => this.getSize(type, pararmeters[index].name, index))
      .join('\n');
    const allSizesSum = mapRange(typesToEncode.length, (n) => `size_${n}`).join('+');

    const cairoParams = pararmeters.map((p) => `${p.name} : ${p.type}`).join(',');

    const funcName = `${this.functionName}${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (bytes_ptr : felt):`,
      `   alloc_locals`,
      `   # Gather all sizes`,
      `   ${allSizes}`,
      `   let (max_length : Uint256) = felt_to_uint256(${allSizesSum})`,
      `   # Init bytes array`,
      `   let (${memLoc} : felt) = wm_new(max_length, ${uint256(1)})`,
      `   let ${currIndex} = 0`,
      `   # Encode each value`,
      ...encodingCode,
      `   return (${memLoc})`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return funcName;
  }

  protected generateTypeEncoding(
    type: TypeNode,
    memLoc: string,
    currIndex: string,
    currParam: string,
    currParamSize: string,
  ): string {
    if (isDynamicArray(type) || type instanceof ArrayType) {
      const funcName = this.generateInlineArrayEncodingFunction(type);
      const args = [memLoc, currIndex, currParam, 0, currParamSize];
      return `${funcName}(${args.join(',')})`;
    }

    if (isValueType(type)) {
      const size = getTypeByteSize(type);
      const funcName = this.getValueTypeEncodingFunction(size);
      const args = [memLoc, currIndex, `${currIndex} + ${currParamSize}`, currParam, '0'];
      if (size < 32) {
        args.push(`${size}`);
      }
      return `${funcName}(${args.join(',')})`;
    }

    throw new TranspileFailedError(
      `Could not genereate packed abi encoding for ${printTypeNode(type)}`,
    );
  }

  protected getValueTypeEncodingFunction(size: number | bigint) {
    const funcName = size < 32 ? 'fixed_bytes_to_dynamic_array' : 'fixed_bytes256_to_dynamic_array';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  public generateInlineArrayEncodingFunction(type: ArrayType | StringType | BytesType): string {
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
          `let (array_index256) = felt_to_uint256(array_index)`,
          `let (elem_loc : felt) = wm_index_dyn(array_ptr, array_index256, ${elementTSize256})`,
        ].join('\n')
      : `let elem_loc : felt = array_ptr + ${mul('array_index', cairoElementT.width)}`;

    const readFunc = this.memoryRead.getOrCreate(cairoElementT);
    const readElementCode = `let (elem : ${cairoElementT.toString()}) = ${readFunc}(elem_loc)`;

    const elementByteSize = getTypeByteSize(elementT);
    const encodingFunc = this.generateTypeEncoding(
      elementT,
      'bytes_ptr',
      'bytes_index',
      'elem',
      `${elementByteSize}`,
    );

    const funcName = `aep_array_${this.auxiliarGeneratedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(`,
      `  bytes_ptr : felt,`,
      `  bytes_index : felt,`,
      `  array_ptr : felt,`,
      `  array_index : felt,`,
      `  array_length : felt`,
      `):`,
      `  alloc_locals`,
      `  if array_index == array_length:`,
      `    return ()`,
      `  end`,
      `  ${getElemLoc}`,
      `  ${readElementCode}`,
      `  ${encodingFunc}`,
      `  return ${funcName}(`,
      `     bytes_ptr,`,
      `     bytes_index + ${elementByteSize},`,
      `     array_ptr,`,
      `     array_index + 1,`,
      `     array_length`,
      `  )`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    if (isDynamicArray(type)) {
      this.requireImport('warplib.memory', 'wm_index_dyn');
    }

    const arrayFunc = { name: funcName, code: code };
    this.auxiliarGeneratedFunctions.set(key, arrayFunc);
    return arrayFunc.name;
  }

  /*
   * Size can be obtained fairly straigtforward since packed abi encoding doesn't allows
   * nested structures
   */
  protected getSize(type: TypeNode, cairoVar: string, suffix: string | number): string {
    const sizeVar = `let size_${suffix}`;
    if (isDynamicArray(type)) {
      this.requireImport('warplib.memory', 'wm_dyn_array_length');
      this.requireImport('warplib.maths.utils', 'narrow_safe');
      const elemenT = getElementType(type);
      return [
        `let (length256_${suffix}) = wm_dyn_array_length(${cairoVar})`,
        `let (length_${suffix}) = narrow_safe(length256_${suffix})`,
        `${sizeVar} = ${mul(`length_${suffix}`, getTypeByteSize(elemenT))}`,
      ].join('\n');
    }

    if (type instanceof ArrayType && type.size !== undefined) {
      return [`let length_${suffix} = ${type.size}`, `${sizeVar} = ${getTypeByteSize(type)}`].join(
        '\n',
      );
    }

    return `${sizeVar} = ${getTypeByteSize(type)}`;
  }
}

function mul(cairoVar: string, val: number | bigint) {
  if (val === 1) return cairoVar;
  return `${cairoVar} * ${val}`;
}
