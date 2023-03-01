import { UnaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { bound, forAllWidths, IntFunction, mask, WarplibFunctionInfo } from '../../utils';

// This satisfies the solidity convention of -type(intX).min = type(intX).min
export function negate(): WarplibFunctionInfo {
  return {
    fileName: 'negate',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_neg',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_negate256{range_check_ptr}(op : Uint256) -> (res : Uint256){',
          '    let (res) = uint256_neg(op);',
          '    return (res,);',
          '}',
        ].join('\n');
      } else {
        // Could also have if op == 0: 0 else limit-op
        return [
          `func warp_negate${width}{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){`,
          `    let raw_res = ${bound(width)} - op;`,
          `    let (res) = bitwise_and(raw_res, ${mask(width)});`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function functionaliseNegate(node: UnaryOperation, ast: AST): void {
  IntFunction(node, node.vSubExpression, 'negate', 'negate', ast);
}
