import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { generateFile, forAllWidths, Comparison } from '../../utils';

export function gt() {
  generateFile(
    'gt',
    [
      `from starkware.cairo.common.math_cmp import is_le_felt`,
      `from starkware.cairo.common.uint256 import Uint256, uint256_le`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_gt256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt):`,
          `    let (le) = uint256_le(lhs, rhs)`,
          `    return (1 - le)`,
          `end`,
        ];
      } else {
        return [
          `func warp_gt${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : felt):`,
          `    if lhs.value == rhs.value:`,
          `        return (0)`,
          `    end`,
          `    let (res) = is_le_felt(rhs.value, lhs.value)`,
          `    return (res)`,
          `end`,
        ];
      }
    }),
  );
}

export function gt_signed() {
  generateFile(
    'gt_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_lt',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.maths.lt_signed import ${mapRange(31, (n) => `warp_lt_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_gt_signed256{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : felt):',
          '    let (res) =  uint256_signed_lt(rhs.value, lhs.value)',
          '    return (res)',
          'end',
        ];
      } else {
        return [
          `func warp_gt_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : felt):`,
          `    let (res) = warp_lt_signed${width}(rhs, lhs)`,
          `    return (res)`,
          'end',
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
  Comparison(node, 'gt', 'always', true, implicitsFn, ast);
}
