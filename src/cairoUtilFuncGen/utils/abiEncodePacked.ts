import {
  ArrayType,
  DataLocation,
  Expression,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  getNodeType,
  IntType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import { isValueType } from '../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';

const IMPLICITS =
  '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}';

// TODO:
// Implement uint encoding (similar to fixed bytes)
// Implement array encoding
//    - Dyanmic Array
//    - Static Array
//  What about other value type like addresses??
export class AbiEncodePacked extends StringIndexedFuncGen {
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

    const pararmeters: string[] = [];
    const encodingCode: string[] = [];
    typesToEncode.forEach((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
      const prefix = `param${index}`;

      if (type instanceof ArrayType) {
        pararmeters.push(`${prefix}_array : ${cairoType.toString()}`);
      } else if (isValueType(type)) {
        pararmeters.push(`${prefix} : ${cairoType.toString()}`);
        encodingCode.push(
          ...[
            this.generateValueTypeEncoding(type, memLoc, currIndex, prefix),
            updateIndex(`size_${index}`),
          ],
        );
      } else {
        throw new TranspileFailedError(
          `AbiEncodePacked for ${printTypeNode(type)} is not supported`,
        );
      }
    });

    const allSizes = typesToEncode
      .map((type, index) => this.getSize(type, pararmeters[index], index))
      .join('\n');
    const allSizesSum = mapRange(typesToEncode.length, (n) => `size_${n}`).join('+');

    const cairoParams = pararmeters.join(',');

    const funcName = `abi_encode_packed${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (bytes_ptr : felt):`,
      `   alloc_locals`,
      `   ${allSizes}`,
      `   let max_length : Uint256 = felt_to_uint256(${allSizesSum})`,
      `   let (${memLoc} : felt) = wm_new(max_length, ${uint256(1)})`,
      `   let ${currIndex} = 0`,
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

  private generateArrayEncoding(type: ArrayType): CairoFunction {
    throw new Error('Not implemented');
  }

  private generateValueTypeEncoding(
    type: TypeNode,
    memLoc: string,
    currIndex: string,
    currParam: string,
  ): string {
    if (type instanceof IntType) {
      const funcName = this.generateIntEncodingCode(type);
    }
    if (type instanceof FixedBytesType) {
      const funcName = this.getFixedBytesEncodingFunction(type);
      const args = [memLoc, currIndex, `${currIndex} + ${type.size}`, currParam, '0'];
      if (type.size < 32) {
        args.push(`${type.size}`);
      }
      return `${funcName}(${args.join(',')})`;
    }

    throw new TranspileFailedError(`AbiEncode generation for ${printTypeNode(type)}`);
  }

  private generateIntEncodingCode(type: IntType): string {
    throw new Error('Not implemented');
  }

  private getFixedBytesEncodingFunction(type: FixedBytesType): string {
    const funcName =
      type.size < 32 ? 'fixed_bytes_to_dynamic_array' : 'fixed_bytes256_to_dynamic_array';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  protected getSize(type: TypeNode, cairoVar: string, suffix: string | number): string {
    const sizeVar = `let size_${suffix}`;
    if (type instanceof ArrayType) {
      if (type.size === undefined) {
        return `${sizeVar} = ${type.size}`;
      } else {
        this.requireImport('warplib.memory', 'wm_dyn_array_length');
        this.requireImport('warplib.maths.utils', 'narrow_safe');
        return [
          `let size256_${suffix} = wm_dyn_array_length(${cairoVar})`,
          `${sizeVar} = narrow_safe(size256_${suffix})`,
        ].join('\n');
      }
    }
    if (type instanceof IntType) {
      return `${sizeVar} = ${type.nBits / 8}`;
    }
    if (type instanceof FixedBytesType) {
      return `${sizeVar} = ${type.size}`;
    }

    throw new TranspileFailedError(
      `Attempted to get size for unexpected type ${printTypeNode(type)} during ABI encoding`,
    );
  }
}
