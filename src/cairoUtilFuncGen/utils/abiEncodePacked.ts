import {
  ArrayType,
  BytesType,
  Expression,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  getNodeType,
  IntType,
  SourceUnit,
  typeNameToTypeNode,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import { isValueType } from '../../utils/nodeTypeProcessing';
import { CairoFunction, StringIndexedFuncGen } from '../base';
import { ExternalDynArrayStructConstructor } from '../calldata/externalDynArray/externalDynArrayStructConstructor';

const IMPLICITS = '';

export class AbiEncodePacked extends StringIndexedFuncGen {
  constructor(
    private externalArrayGen: ExternalDynArrayStructConstructor,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
    const exprTypes = expressions.map(
      (expr) => generalizeType(getNodeType(expr, this.ast.compilerVersion))[0],
    );
    const functionName = this.getOrCreate(exprTypes);

    throw new Error('Not implemented');
  }

  getOrCreate(typesToEncode: TypeNode[]): string {
    const key = typesToEncode.map((t) => t.pp()).join(',');
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const pararmeters: string[] = [];
    const encodeCode: string[] = [];

    typesToEncode.forEach((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.MemoryAllocation);
      const prefix = `arg_${index}`;

      if (type instanceof ArrayType) {
        pararmeters.push(`${prefix}_array : ${cairoType.toString()}`);
      } else if (isValueType(type)) {
        pararmeters.push(`${prefix} : ${cairoType.toString()}`);
      } else {
        throw new TranspileFailedError(
          `AbiEncodePacked for ${printTypeNode(type)} is not supported`,
        );
      }
    });

    const cairoParams = pararmeters.join(',');
    const resultStruct = this.externalArrayGen.getOrCreate(
      typeNameToTypeNode(createBytesTypeName(this.ast)),
    );

    const funcName = `abi_encode_packed${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(${cairoParams}) -> (bytes_array : ${resultStruct}):`,
      `   alloc_locals`,
      `   let total_size : felt = 0`,
      `   let (bytes_ptr : felt*) = wm_alloc()`,
      ...encodeCode,
      `   let result = ${resultStruct}(total_size, bytes_ptr)`,
      `end`,
    ];

    this.requireImport('starkware.cairo.common.alloc', 'alloc');

    throw new Error('Not implemented');
  }

  private generateArrayEncoding(type: ArrayType): CairoFunction {
    throw new Error('Not implemented');
  }

  private generateValueTypeEncodingCode(type: TypeNode): string {
    if (type instanceof IntType) return this.generateIntEncodingCode(type);
    if (type instanceof FixedBytesType) return this.getFixedByteEncodingFunction(type);

    throw new TranspileFailedError(`AbiEncode generation for ${printTypeNode(type)}`);
  }

  private generateIntEncodingCode(type: IntType): string {
    throw new Error('Not implemented');
  }

  private getFixedByteEncodingFunction(type: FixedBytesType): string {
    const funcName =
      type.size < 32 ? 'fixed_byte_to_dynamic_array' : 'fixed_byte256_to_dynamic_array';
    this.requireImport('warplib.dynamic_arrays_util', funcName);
    return funcName;
  }

  protected getSize(type: TypeNode, cairoVar: string, suffix: string): string {
    if (type instanceof ArrayType) {
      if (type.size === undefined) {
        return `let size_${suffix} = ${type.size}`;
      } else {
        this.requireImport('warplib.memory', 'wm_dyn_array_length');
        this.requireImport('warplib.maths.utils', 'narrow_safe');
        return [
          `let size256_${suffix} = wm_dyn_array_length(${cairoVar})`,
          `let size_${suffix} = narrow_safe(size256_${suffix})`,
        ].join('\n');
      }
    }
    // if (type instanceof )
    return '';
  }
}
