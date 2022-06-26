import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { forAllWidths, generateFile, IntxIntFunction, mask, msb, msbAndNext } from '../../utils';
import { mapRange } from '../../../utils/utils';

export function add(): void {
  generateFile(
    'add',
    [
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    let (res : Uint256, carry : felt) = uint256_add(lhs, rhs)`,
          `    assert carry = 0`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_add${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    let res = lhs.value + rhs.value`,
          `    let (inRange : felt) = is_le_felt(res, ${mask(width)})`,
          `    assert inRange = 1`,
          `    return (Uint${width}(value=res))`,
          `end`,
        ];
      }
    }),
  );
}

export function add_unsafe(): void {
  generateFile(
    'add_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    let (res : Uint256, _) = uint256_add(lhs, rhs)`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_add_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Uint${width}, rhs : Uint${width}) -> (`,
          `        res : Uint${width}):`,
          `    let (trunc_res) = bitwise_and(lhs.value + rhs.value, ${mask(width)})`,
          `    return (Uint${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

export function add_signed(): void {
  generateFile(
    'add_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Int256, rhs : Int256) -> (res : Int256):`,
          `    let (lhs_extend) = bitwise_and(lhs.value.high, ${msb(128)})`,
          `    let (rhs_extend) = bitwise_and(rhs.value.high, ${msb(128)})`,
          `    let (res : Uint256, carry : felt) = uint256_add(lhs.value, rhs.value)`,
          `    let carry_extend = lhs_extend + rhs_extend + carry*${msb(128)}`,
          `    let (msb) = bitwise_and(res.high, ${msb(128)})`,
          `    let (carry_lsb) = bitwise_and(carry_extend, ${msb(128)})`,
          `    assert msb = carry_lsb`,
          `    return (Int256(value=res))`,
          `end`,
        ];
      } else {
        return [
          `func warp_add_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Int${width}, rhs : Int${width}) -> (`,
          `        res : Int${width}):`,
          `# Do the addition sign extended`,
          `    let (lmsb) = bitwise_and(lhs.value, ${msb(width)})`,
          `    let (rmsb) = bitwise_and(rhs.value, ${msb(width)})`,
          `    let big_res = lhs.value + rhs.value + 2*(lmsb+rmsb)`,
          `# Check the result is valid`,
          `    let (overflowBits) = bitwise_and(big_res,  ${msbAndNext(width)})`,
          `    assert overflowBits * (overflowBits - ${msbAndNext(width)}) = 0`,
          `# Truncate and return`,
          `    let (trunc_res) = bitwise_and(big_res, ${mask(width)})`,
          `    return (Int${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

export function add_signed_unsafe(): void {
  generateFile(
    'add_signed_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_signed_unsafe256{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : Int256):`,
          `    let (res : Uint256, _) = uint256_add(lhs.value, rhs.value)`,
          `    return (Int256(value=res))`,
          `end`,
        ];
      } else {
        return [
          `func warp_add_signed_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    let (trunc_res) = bitwise_and(lhs.value + rhs.value, ${mask(width)})`,
          `    return (Int${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

export function functionaliseAdd(node: BinaryOperation, unsafe: boolean, ast: AST): void {
  const implicitsFn = (width: number, signed: boolean): Implicits[] => {
    if (!unsafe && signed && width === 256) return ['range_check_ptr', 'bitwise_ptr'];
    else if ((!unsafe && !signed) || width === 256) return ['range_check_ptr'];
    else return ['bitwise_ptr'];
  };
  IntxIntFunction(node, 'add', 'always', true, unsafe, implicitsFn, ast);
}
