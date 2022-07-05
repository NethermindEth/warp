import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { generateFile, forAllWidths, Comparison } from '../../utils';

export function ge() {
  generateFile(
    'ge',
    [
      `from starkware.cairo.common.math_cmp import is_le_felt`,
      `from starkware.cairo.common.uint256 import Uint256, uint256_lt`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_ge256{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : felt):`,
          `    let (lt : felt) = uint256_lt(op1, op2)`,
          `    return (1 - lt)`,
          `end`,
        ];
      } else {
        return [
          `func warp_ge${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : felt):`,
          `    let (res) = is_le_felt(lhs.value, rhs.value)`,
          `    return (res)`,
          `end`,
        ];
      }
    }),
  );
}

export function ge_signed() {
  generateFile(
    'ge_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_le',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.maths.le_signed import ${mapRange(31, (n) => `warp_le_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_ge_signed256{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : felt):',
          '     let (res) =  uint256_signed_le(rhs.value, lhs.value)',
          '     return (res)',
          'end',
        ];
      } else {
        return [
          `func warp_ge_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : felt):`,
          `    let (res) = warp_le_signed${width}(rhs, lhs)`,
          `    return (res)`,
          'end',
        ];
      }
    }),
  );
}

export function functionaliseGe(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean, signed: boolean): Implicits[] => {
    if (wide || !signed) return ['range_check_ptr'];
    else return ['range_check_ptr', 'bitwise_ptr'];
  };
  Comparison(node, 'ge', 'always', true, implicitsFn, ast);
}
