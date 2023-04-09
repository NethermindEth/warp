import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { mapRange } from '../../../utils/utils';
import { forAllWidths, Comparison, WarplibFunctionInfo } from '../../utils';

export function gt_signed(): WarplibFunctionInfo {
  return {
    fileName: 'gt_signed',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_lt',
      `from warplib.maths.lt_signed import ${mapRange(31, (n) => `warp_lt_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_gt_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt){',
          '    let (res) =  uint256_signed_lt(rhs, lhs);',
          '    return (res,);',
          '}',
        ].join('\n');
      } else {
        return [
          `func warp_gt_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          '        lhs : felt, rhs : felt) -> (res : felt){',
          `    let (res) = warp_lt_signed${width}(rhs, lhs);`,
          `    return (res,);`,
          '}',
        ].join('\n');
      }
    }),
  };
}

export function functionaliseGt(node: BinaryOperation, ast: AST): void {
  Comparison(node, 'gt', 'signedOrWide', true, ast);
}
