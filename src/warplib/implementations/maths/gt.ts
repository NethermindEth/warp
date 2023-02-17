import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { generateFile, forAllWidths, Comparison } from '../../utils';

export function gt_signed() {
  generateFile(
    'gt_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import u256, uint256_signed_lt',
      `from warplib.maths.lt_signed import ${mapRange(31, (n) => `warp_lt_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_gt_signed256{range_check_ptr}(lhs : u256, rhs : u256) -> (res : felt){',
          '    let (res) =  uint256_signed_lt(rhs, lhs);',
          '    return (res,);',
          '}',
        ];
      } else {
        return [
          `func warp_gt_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          '        lhs : felt, rhs : felt) -> (res : felt){',
          `    let (res) = warp_lt_signed${width}(rhs, lhs);`,
          `    return (res,);`,
          '}',
        ];
      }
    }),
  );
}

export function functionaliseGt(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean, signed: boolean): Implicits[] => {
    if (wide || !signed) return ['range_check_ptr'];
    else return ['range_check_ptr', 'bitwise_ptr'];
  };
  Comparison(node, 'gt', 'signedOrWide', true, implicitsFn, ast);
}
