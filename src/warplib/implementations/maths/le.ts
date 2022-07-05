import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { generateFile, forAllWidths, msb, Comparison } from '../../utils';
import { mapRange } from '../../../utils/utils';

export function le() {
  generateFile(
    'le',
    [
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_le',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_le256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (result : felt):`,
          '    return uint256_le(lhs, rhs)',
          'end',
        ];
      } else {
        return [
          `func warp_le${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : felt):`,
          '    return is_le_felt(lhs.value, rhs.value)',
          'end',
        ];
      }
    }),
  );
}

export function le_signed() {
  generateFile(
    'le_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_le',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_le_signed${width}{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : felt):`,
          '    let (res) = uint256_signed_le(lhs.value, rhs.value)',
          '    return (res)',
          'end',
        ];
      } else {
        return [
          `func warp_le_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : felt):`,
          `    alloc_locals`,
          `    let (lhs_msb : felt) = bitwise_and(lhs.value, ${msb(width)})`,
          `    let (rhs_msb : felt) = bitwise_and(rhs.value, ${msb(width)})`,
          `    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr`,
          `    if lhs_msb == 0:`,
          `        # lhs >= 0`,
          `        if rhs_msb == 0:`,
          `            # rhs >= 0`,
          `            let (result) = is_le_felt(lhs.value, rhs.value)`,
          `            return (result)`,
          `        else:`,
          `            # rhs < 0`,
          `            return (0)`,
          `        end`,
          `    else:`,
          `        # lhs < 0`,
          `        if rhs_msb == 0:`,
          `            # rhs >= 0`,
          `            return (1)`,
          `        else:`,
          `            # rhs < 0`,
          `            # (signed) lhs <= rhs <=> (unsigned) lhs >= rhs`,
          `            let (result) = is_le_felt(rhs.value, lhs.value)`,
          `            return (result)`,
          `        end`,
          `    end`,
          `end`,
        ];
      }
    }),
  );
}

export function functionaliseLe(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean, signed: boolean): Implicits[] => {
    if (!wide && signed) return ['range_check_ptr', 'bitwise_ptr'];
    else return ['range_check_ptr'];
  };

  Comparison(node, 'le', 'always', true, implicitsFn, ast);
}
