import { DataLocation, FunctionCall, getNodeType, PointerType, TypeName } from 'solc-typed-ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';

const IMPLICITS = '{range_check_ptr, warp_memory : DictAccess*}';

export class MemoryArrayConcat extends StringIndexedFuncGen {
  gen(concat: FunctionCall) {
    const args = concat.vArguments;
    args.forEach((expr) => {
      const exprType = getNodeType(expr, this.ast.compilerVersion);
      if (!(exprType instanceof PointerType))
        throw new NotSupportedYetError(
          `Concatenation of expression ${printNode(expr)} of type ${printTypeNode(
            exprType,
          )} not supported yet`,
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

    const name = this.getOrCreate(args.length);
    const functionStub = createCairoFunctionStub(
      name,
      inputs,
      [output],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      concat,
    );

    return createCallToFunction(functionStub, args, this.ast);
  }

  private getOrCreate(argAmount: number): string {
    const existing = this.generatedFunctions.get(argAmount.toString());
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoFunc = this.genearteBytesConcat(argAmount);
    this.generatedFunctions.set(argAmount.toString(), cairoFunc);
    return cairoFunc.name;
  }

  private genearteBytesConcat(argAmount: number): CairoFunction {
    const funcName = `concat_${argAmount}`;

    if (argAmount === 0) {
      this.requireImport('warplib.memory', 'wm_new');
      return {
        name: funcName,
        code: [
          `func ${funcName}${IMPLICITS}() -> (res_loc : felt):`,
          `   alloc_locals`,
          `   let (res_loc) = wm_new(${uint256(0)}, ${uint256(1)})`,
          `   return (res_loc)`,
          `end`,
        ].join('\n'),
      };
    }

    const args = mapRange(argAmount, (n) => `arg_${n} : felt`).join(', ');
    const code = [
      `func ${funcName}${IMPLICITS}(${args}) -> (res_loc : felt):`,
      `    alloc_locals`,
      `    # Get all sizes`,
      ...mapRange(argAmount, (n) =>
        [
          `let (size256_${n}) = wm_dyn_array_length(arg_${n})`,
          `let size_${n} = size256_${n}.low + size256_${n}.high*128`,
        ].join('\n'),
      ),
      `    let total_length = ${mapRange(argAmount, (n) => `size_${n}`).join('+')}`,
      `    let (total_length256) = felt_to_uint256(total_length)`,
      `    let (res_loc) = wm_new(total_length256, ${uint256(1)})`,
      `    # Copy values`,
      `    let start_loc = 0`,
      ...mapRange(argAmount, (n) => {
        const copy = [
          `let end_loc = start_loc + size_${n}`,
          `dynamic_array_copy_felt(res_loc, start_loc, end_loc, arg_${n}, 0)`,
          `let start_loc = end_loc`,
        ];
        return n < argAmount - 1 ? copy.join('\n') : copy.slice(0, -1).join('\n');
      }),
      `    return (res_loc)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'wm_dyn_array_length');
    this.requireImport('warplib.memory', 'wm_new');
    this.requireImport('warplib.dynamic_arrays_util', 'dynamic_array_copy_felt');

    return { name: funcName, code: code };
  }
}
