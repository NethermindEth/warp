import assert from 'assert';
import {
  DataLocation,
  Expression,
  FunctionCall,
  getNodeType,
  MemberAccess,
  PointerType,
  TypeName,
} from 'solc-typed-ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { CairoFunction, StringIndexedFuncGen } from '../base';

const IMPLICITS = '{range_check_ptr, warp_memory : DictAccess*}';

export class MemoryConcat extends StringIndexedFuncGen {
  gen(concat: FunctionCall) {
    const args = concat.vArguments;
    args.forEach((expr) => {
      const exprType = getNodeType(expr, this.ast.compilerVersion);
      assert(
        exprType instanceof PointerType,
        `Concatenation of expression ${printNode(expr)} of type ${printTypeNode(
          exprType,
        )} not supported yet`,
      );
      assert(
        exprType.location === DataLocation.Memory,
        `Concatenation of '${exprType.location}' different than memory`,
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

    this.requireImport('warplib.memory', 'wm_new');
    if (argAmount === 0) {
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
    const copyFunc = this.generateFeltCopy();
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
          `${copyFunc}(res_loc, start_loc, end_loc, arg_${n}, 0)`,
          `let start_loc = end_loc`,
        ];
        return n < argAmount - 1 ? copy.join('\n') : copy.slice(0, -1).join('\n');
      }),
      `    return (res_loc)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'wm_dyn_array_length');

    return { name: funcName, code: code };
  }

  private generateFeltCopy() {
    const func = this.generatedFunctions.get('felt_copy');
    if (func !== undefined) return func.name;

    const funcName = 'felt_copy';
    const code = [
      `func ${funcName}${IMPLICITS}(
        res_loc, res_index, res_end_loc, arg_loc, arg_index):`,
      `   alloc_locals`,
      `   if res_index == res_end_loc:`,
      `       return ()`,
      `   end`,
      `   let (res_index256) = felt_to_uint256(res_index)`,
      `   let (arg_index256) = felt_to_uint256(arg_index)`,
      `   let (res_index_loc) = wm_index_dyn(res_loc, res_index256, ${uint256(1)})`,
      `   let (arg_index_loc) = wm_index_dyn(arg_loc, arg_index256, ${uint256(1)})`,
      `   let (arg_elem) = wm_read_felt(arg_index_loc)`,
      `   wm_write_felt(res_index_loc, arg_elem)`,
      `   return ${funcName}(res_loc, res_index + 1, res_end_loc, arg_loc, arg_index + 1)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.memory', 'wm_read_felt');
    this.requireImport('warplib.memory', 'wm_write_felt');
    this.requireImport('warplib.memory', 'wm_index_dyn');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.maths.utils', 'felt_to_uint256');

    this.generatedFunctions.set(funcName, { name: funcName, code: code });
    return funcName;
  }
}
