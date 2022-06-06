import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  FunctionCall,
  getNodeType,
  IntType,
  PointerType,
  TypeName,
  TypeNode,
} from 'solc-typed-ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { Implicits } from '../../utils/implicits';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';

export class MemoryArrayConcat extends StringIndexedFuncGen {
  gen(concat: FunctionCall) {
    const args = concat.vArguments;
    args.forEach((expr) => {
      const exprType = getNodeType(expr, this.ast.compilerVersion);
      if (
        !(exprType instanceof PointerType && exprType.to instanceof ArrayType) &&
        !(exprType instanceof IntType)
      )
        throw new TranspileFailedError(
          `Unexpected type ${printTypeNode(exprType)} in ${printNode(expr)} to concatenate.` +
            'Expected IntType or ArrayType',
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

    const implicits: Implicits[] = argTypes.some((type) => type instanceof IntType)
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
        assert(type instanceof IntType);
        return `B${type.nBits}`;
      })
      .join('');

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const implicits = argTypes.some((type) => type instanceof IntType)
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
      const cairoType = CairoType.fromSol(
        type,
        this.ast,
        TypeConversionContext.MemoryAllocation,
      ).toString();
      return `arg_${index} : ${cairoType}`;
    });
    const code = [
      `func ${funcName}${implicits}(${cairoArgs}) -> (res_loc : felt):`,
      `    alloc_locals`,
      `    # Get all sizes`,
      ...argTypes.map(getSize),
      `    let total_length = ${mapRange(argAmount, (n) => `size_${n}`).join('+')}`,
      `    let (total_length256) = felt_to_uint256(total_length)`,
      `    let (res_loc) = wm_new(total_length256, ${uint256(1)})`,
      `    # Copy values`,
      `    let start_loc = 0`,
      ...mapRange(argAmount, (n) => {
        const copy = [
          `let end_loc = start_loc + size_${n}`,
          getCopyFunctionCall(argTypes[n], n),
          `let start_loc = end_loc`,
        ];
        return n < argAmount - 1 ? copy.join('\n') : copy.slice(0, -1).join('\n');
      }),
      `    return (res_loc)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'wm_new');
    argTypes.forEach((type) => {
      if (type instanceof PointerType) {
        this.requireImport('warplib.memory', 'wm_dyn_array_length');
        this.requireImport('warplib.dynamic_arrays_util', 'dynamic_array_copy_felt');
      } else if (type instanceof IntType) {
        type.nBits / 8 < 32
          ? this.requireImport('warplib.dynamic_arrays_util', 'fixed_byte_to_dynamic_array')
          : this.requireImport('warplib.dynamic_arrays_util', 'fixed_byte256_to_dynamic_array');
      }
    });

    return { name: funcName, code: code };
  }
}
function getSize(type: TypeNode, index: number): string {
  if (type instanceof PointerType)
    return [
      `let (size256_${index}) = wm_dyn_array_length(arg_${index})`,
      `let size_${index} = size256_${index}.low + size256_${index}.high*128`,
    ].join('\n');

  assert(type instanceof IntType);
  return `let size_${index} = ${type.nBits / 8}`;
}

function getCopyFunctionCall(type: TypeNode, index: number): string {
  if (type instanceof PointerType)
    return `dynamic_array_copy_felt(res_loc, start_loc, end_loc, arg_${index}, 0)`;

  assert(type instanceof IntType);

  if (type.nBits / 8 < 32)
    return `fixed_byte_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, size_${index} - 1, size_${index})`;

  return `fixed_byte256_to_dynamic_array(res_loc, start_loc, end_loc, arg_${index}, 31)`;
}
