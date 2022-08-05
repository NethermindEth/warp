import assert from 'assert';
import {
  DataLocation,
  FixedBytesType,
  FunctionCall,
  getNodeType,
  IntType,
  PointerType,
  TypeName,
  TypeNode,
} from 'solc-typed-ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { Implicits } from '../../utils/implicits';
import { isDynamicArray } from '../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { getIntOrFixedByteBitWidth, uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';

export class MemoryArrayConcat extends StringIndexedFuncGen {
  gen(concat: FunctionCall) {
    const args = concat.vArguments;
    args.forEach((expr) => {
      const exprType = getNodeType(expr, this.ast.compilerVersion);
      if (
        !isDynamicArray(exprType) &&
        !(exprType instanceof IntType || exprType instanceof FixedBytesType)
      )
        throw new TranspileFailedError(
          `Unexpected type ${printTypeNode(exprType)} in ${printNode(expr)} to concatenate.` +
            'Expected FixedBytes, IntType, ArrayType, BytesType, or StringType',
        );
    });

    const inputs: [string, TypeName, DataLocation][] = mapRange(args.length, (n) => [
      `arg_${n}`,
      typeNameFromTypeNode(getNodeType(args[n], this.ast.compilerVersion), this.ast),
      DataLocation.Memory,
    ]);
    const output: [string, TypeName, DataLocation] = [
      'res_loc',
      typeNameFromTypeNode(getNodeType(concat, this.ast.compilerVersion), this.ast),
      DataLocation.Memory,
    ];

    const argTypes = args.map((e) => getNodeType(e, this.ast.compilerVersion));
    const name = this.getOrCreate(argTypes);

    const implicits: Implicits[] = argTypes.some(
      (type) => type instanceof IntType || type instanceof FixedBytesType,
    )
      ? ['bitwise_ptr', 'range_check_ptr', 'warp_memory']
      : ['range_check_ptr', 'warp_memory'];

    const functionStub = createCairoFunctionStub(
      name,
      inputs,
      [output],
      implicits,
      this.ast,
      concat,
    );

    return createCallToFunction(functionStub, args, this.ast);
  }

  private getOrCreate(argTypes: TypeNode[]): string {
    const key = argTypes
      .map((type) => {
        if (type instanceof PointerType) return 'A';
        return `B${getIntOrFixedByteBitWidth(type)}`;
      })
      .join('');

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const implicits = argTypes.some(
      (type) => type instanceof IntType || type instanceof FixedBytesType,
    )
      ? '{bitwise_ptr : BitwiseBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}'
      : '{range_check_ptr : felt, warp_memory : DictAccess*}';

    const cairoFunc = this.genearteBytesConcat(argTypes, implicits);
    this.generatedFunctions.set(key, cairoFunc);
    return cairoFunc.name;
  }

  private genearteBytesConcat(argTypes: TypeNode[], implicits: string): CairoFunction {
    const argAmount = argTypes.length;
    const funcName = `concat${this.generatedFunctions.size}_${argAmount}`;

    if (argAmount === 0) {
      this.requireImport('starkware.cairo.common.uint256', 'Uint256');
      this.requireImport('warplib.memory', 'wm_new');
      return {
        name: funcName,
        code: [
          `func ${funcName}${implicits}() -> (res_loc : felt):`,
          `   alloc_locals`,
          `   let (res_loc) = wm_new(${uint256(0)}, ${uint256(1)})`,
          `   return (res_loc)`,
          `end`,
        ].join('\n'),
      };
    }

    const cairoArgs = argTypes.map((type, index) => {
      const cairoType = CairoType.fromSol(type, this.ast).toString();
      return `arg_${index} : ${cairoType}`;
    });
    const code = [
      `func ${funcName}${implicits}(${cairoArgs}) -> (res_loc : felt):`,
      `    alloc_locals`,
      `    # Get all sizes`,
      ...argTypes.map(this.getSize),
      `    let total_length = ${mapRange(argAmount, (n) => `size_${n}`).join('+')}`,
      `    let (total_length256) = felt_to_uint256(total_length)`,
      `    let (res_loc) = wm_new(total_length256, ${uint256(1)})`,
      `    # Copy values`,
      `    let start_loc = 0`,
      ...mapRange(argAmount, (n) => {
        const copy = [
          `let end_loc = start_loc + size_${n}`,
          this.getCopyFunctionCall(argTypes[n], n),
          `let start_loc = end_loc`,
        ];
        return n < argAmount - 1 ? copy.join('\n') : copy.slice(0, -1).join('\n');
      }),
      `    return (res_loc)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    this.requireImport('warplib.memory', 'wm_new');

    return { name: funcName, code: code };
  }

  getSize(type: TypeNode, index: number): string {
    if (type instanceof PointerType) {
      this.requireImport('warplib.memory', 'wm_dyn_array_length');
      this.requireImport('warplib.maths.utils', 'narrow_safe');
      return [
        `let (size256_${index}) = wm_dyn_array_length(arg_${index})`,
        `let size_${index} = narrow_safe(size256_${index})`,
      ].join('\n');
    }

    if (type instanceof IntType) {
      return `let size_${index} = ${type.nBits / 8}`;
    } else if (type instanceof FixedBytesType) {
      return `let size_${index} = ${type.size}`;
    } else {
      throw new TranspileFailedError(
        `Attempted to get size for unexpected type ${printTypeNode(type)} in concat`,
      );
    }
  }

  getCopyFunctionCall(type: TypeNode, index: number): string {
    if (type instanceof PointerType) {
      this.requireImport('warplib.dynamic_arrays_util', 'dynamic_array_copy_felt');
      return `dynamic_array_copy_felt(res_loc, start_loc, end_loc, arg_${index}, 0)`;
    }

    assert(type instanceof FixedBytesType);
    if (type.size < 32) {
      this.requireImport('warplib.dynamic_arrays_util', 'fixed_byte_to_dynamic_array');
      return `fixed_byte_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 0, size_${index})`;
    }
    this.requireImport('warplib.dynamic_arrays_util', 'fixed_byte256_to_dynamic_array');
    return `fixed_byte256_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 0)`;
  }
}
