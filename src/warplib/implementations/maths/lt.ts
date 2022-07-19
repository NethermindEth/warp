import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { generateFile, forAllWidths, Comparison } from '../../utils';

export function lt() {
  generateFile(
    'lt',
    [
      `from starkware.cairo.common.math_cmp import is_le_felt`,
      `from starkware.cairo.common.uint256 import Uint256, uint256_lt`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_lt256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt):`,
          `    let (res) = uint256_lt(lhs, rhs)`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_lt${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : felt):`,
          `    if lhs.value == rhs.value :`,
          `        return (0)`,
          `    end`,
          `    let (res) = is_le_felt(lhs.value, rhs.value)`,
          `    return (res)`,
          `end`,
        ];
      }
    }),
  );
}

export function lt_signed() {
  generateFile(
    'lt_signed',
    [
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_lt',
      'from warplib.maths.utils import felt_to_uint256',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.maths.le_signed import ${mapRange(31, (n) => `warp_le_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_lt_signed256{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : felt):',
          '    let (res) = uint256_signed_lt(lhs.value, rhs.value)',
          '    return (res)',
          'end',
        ];
      } else {
        return [
          `func warp_lt_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : felt):`,
          '    if lhs.value == rhs.value:',
          '        return (0)',
          '    end',
          `    let (res) = warp_le_signed${width}(lhs, rhs)`,
          `    return (res)`,
          'end',
        ];
      }
    }),
  );
}

export function functionaliseLt(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean, signed: boolean): Implicits[] => {
    if (!wide && signed) return ['range_check_ptr', 'bitwise_ptr'];
    else return ['range_check_ptr'];
  };

  Comparison(node, 'lt', 'always', true, implicitsFn, ast);
}
