import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { forAllWidths, generateFile, IntxIntFunction, mask, msb, msbAndNext } from '../../utils';

export function add(): void {
  generateFile(
    'add',
    [
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
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
          `func warp_add${width}{range_check_ptr}(lhs : felt, rhs : felt) -> (res : felt):`,
          `    let res = lhs + rhs`,
          `    let (inRange : felt) = is_le_felt(res, ${mask(width)})`,
          `    assert inRange = 1`,
          `    return (res)`,
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
          `func warp_add_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt):`,
          `    return bitwise_and(lhs + rhs, ${mask(width)})`,
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
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    let (lhs_extend) = bitwise_and(lhs.high, ${msb(128)})`,
          `    let (rhs_extend) = bitwise_and(rhs.high, ${msb(128)})`,
          `    let (res : Uint256, carry : felt) = uint256_add(lhs, rhs)`,
          `    let carry_extend = lhs_extend + rhs_extend + carry*${msb(128)}`,
          `    let (msb) = bitwise_and(res.high, ${msb(128)})`,
          `    let (carry_lsb) = bitwise_and(carry_extend, ${msb(128)})`,
          `    assert msb = carry_lsb`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_add_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt):`,
          `    let raw_res = lhs + rhs`,
          `    let (overflowBits) = bitwise_and(raw_res, ${msbAndNext(width)})`,
          `    assert overflowBits * (overflowBits - ${msbAndNext(width)}) = 0`,
          `    return (raw_res)`,
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
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_signed_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    let (res : Uint256, _) = uint256_add(lhs, rhs)`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_add_signed_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : felt, rhs : felt) -> (res : felt):`,
          `    return bitwise_and(lhs + rhs, ${mask(width)})`,
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
