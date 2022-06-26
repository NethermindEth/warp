import assert from 'assert';
import { BinaryOperation, getNodeType, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printTypeNode } from '../../../utils/astPrinter';
import { Implicits } from '../../../utils/implicits';
import {
  generateFile,
  forAllWidths,
  bound,
  mask,
  msb,
  msbAndNext,
  IntxIntFunction,
} from '../../utils';

import { mapRange } from '../../../utils/utils';

export function sub(): void {
  generateFile(
    'sub',
    [
      `from starkware.cairo.common.bitwise import bitwise_and`,
      `from starkware.cairo.common.cairo_builtins import BitwiseBuiltin`,
      `from starkware.cairo.common.math_cmp import is_le_felt`,
      `from starkware.cairo.common.uint256 import Uint256, uint256_le`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width == 256) {
        return [
          `const MASK128 = 2 ** 128 - 1`,
          `const BOUND128 = 2 ** 128`,
          ``,
          `func warp_sub256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (`,
          `    res : Uint256`,
          `):`,
          `    let (safe) = uint256_le(rhs, lhs)`,
          `    assert safe = 1`,
          `    # preemptively borrow from bit128`,
          `    let (low_safe) = bitwise_and(BOUND128 + lhs.low - rhs.low, MASK128)`,
          `    let low_unsafe = lhs.low - rhs.low`,
          `    if low_safe == low_unsafe:`,
          `        # the borrow was not used`,
          `        return (Uint256(low_safe, lhs.high - rhs.high))`,
          `    else:`,
          `        # the borrow was used`,
          `        return (Uint256(low_safe, lhs.high - rhs.high - 1))`,
          `    end`,
          `end`,
        ];
      } else {
        return [
          `func warp_sub${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    let (valid) = is_le_felt(rhs.value, lhs.value)`,
          `    assert valid = 1`,
          `    return (Uint${width}(value=(lhs.value - rhs.value)))`,
          `end`,
        ];
      }
    }),
  );
}

export function sub_unsafe(): void {
  generateFile(
    'sub_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_sub_unsafe256{bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (`,
          `        result : Uint256):`,
          '    #preemptively borrow from bit128',
          `    let (low_safe) = bitwise_and(${bound(128)} + lhs.low - rhs.low, ${mask(128)})`,
          `    let low_unsafe = lhs.low - rhs.low`,
          `    if low_safe == low_unsafe:`,
          '        #the borrow was not used',
          `        let (high) = bitwise_and(${bound(128)} + lhs.high - rhs.high, ${mask(128)})`,
          `        return (Uint256(low_safe, high))`,
          `    else:`,
          '        #the borrow was used',
          `        let (high) = bitwise_and(${bound(128)} + lhs.high - rhs.high - 1, ${mask(128)})`,
          `        return (Uint256(low_safe, high))`,
          `    end`,
          `end`,
        ];
      } else {
        return [
          `func warp_sub_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Uint${width}, rhs : Uint${width}) -> (`,
          `        res : Uint${width}):`,
          `    let res : felt = ${bound(width)} + lhs.value - rhs.value`,
          `    let (trunc_res) = bitwise_and(res, ${mask(width)})`,
          `    return (Uint${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

export function sub_signed(): void {
  generateFile(
    'sub_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_signed_le, uint256_sub, uint256_not',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_sub_signed${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Int256, rhs : Int256) -> (`,
          `        res : Int256):`,
          `    # First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs.value.high, ${msb(128)})`,
          `    let (right_msb : felt) = bitwise_and(rhs.value.high, ${msb(128)})`,
          `    let left_overflow : felt = left_msb / ${msb(128)}`,
          `    let right_overflow : felt = right_msb / ${msb(128)}`,
          ``,
          `    # Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let (right_flipped : Uint256) = uint256_not(rhs.value)`,
          `    let (right_neg, overflow) = uint256_add(right_flipped, Uint256(1,0))`,
          `    let right_overflow_neg = overflow + 1 - right_overflow`,
          `    let (res, res_base_overflow) = uint256_add(lhs.value, right_neg)`,
          `    let res_overflow = res_base_overflow + left_overflow + right_overflow_neg`,
          ``,
          `    # Check if the result fits in the correct width`,
          `    let (res_msb : felt) = bitwise_and(res.high, ${msb(128)})`,
          `    let (res_overflow_lsb : felt) = bitwise_and(res_overflow, 1)`,
          `    assert res_overflow_lsb * ${msb(128)} = res_msb`,
          ``,
          `    # Narrow and return`,
          `    return (Int256(value=res))`,
          `end`,
        ];
      } else {
        return [
          `func warp_sub_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Int${width}, rhs : Int${width}) -> (`,
          `        res : Int${width}):`,
          `    # First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs.value, ${msb(width)})`,
          `    let (right_msb : felt) = bitwise_and(rhs.value, ${msb(width)})`,
          `    let left_safe : felt = lhs.value + 2 * left_msb`,
          `    let right_safe : felt = rhs.value + 2 * right_msb`,
          ``,
          `    # Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt = ${bound(width + 1)} - right_safe`,
          `    let extended_res : felt = left_safe + right_neg`,
          ``,
          `    # Check if the result fits in the correct width`,
          `    let (overflowBits) = bitwise_and(extended_res, ${msbAndNext(width)})`,
          `    assert overflowBits * (overflowBits - ${msbAndNext(width)}) = 0`,
          ``,
          `    # Narrow and return`,
          `    let (trunc_res) = bitwise_and(extended_res, ${mask(width)})`,
          `    return (Int${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

export function sub_signed_unsafe(): void {
  generateFile(
    'sub_signed_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_sub',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_sub_signed_unsafe256{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : Int256):',
          '    let (res:Uint256) = uint256_sub(lhs.value, rhs.value)',
          '    return (Int256(value=res))',
          'end',
        ];
      } else {
        return [
          `func warp_sub_signed_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    # First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs.value, ${msb(width)})`,
          `    let (right_msb : felt) = bitwise_and(rhs.value, ${msb(width)})`,
          `    let left_safe : felt = lhs.value + 2 * left_msb`,
          `    let right_safe : felt = rhs.value + 2 * right_msb`,
          ``,
          `    # Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt = ${bound(width + 1)} - right_safe`,
          `    let extended_res : felt = left_safe + right_neg`,
          ``,
          `    # Narrow and return`,
          `    let (trunc_res) = bitwise_and(extended_res, ${mask(width)})`,
          `    return (Int${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

//func warp_sub{range_check_ptr}(lhs : felt, rhs : felt) -> (res : felt):
//func warp_sub256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):

export function functionaliseSub(node: BinaryOperation, unsafe: boolean, ast: AST): void {
  const implicitsFn = (width: number, signed: boolean): Implicits[] => {
    if (signed) {
      if (width === 256) return ['range_check_ptr', 'bitwise_ptr'];
      else return ['bitwise_ptr'];
    } else {
      if (unsafe) {
        return ['bitwise_ptr'];
      } else {
        if (width === 256) return ['range_check_ptr', 'bitwise_ptr'];
        else return ['range_check_ptr'];
      }
    }
  };
  const typeNode = getNodeType(node, ast.compilerVersion);
  assert(
    typeNode instanceof IntType,
    `Expected IntType for subtraction, got ${printTypeNode(typeNode)}`,
  );
  IntxIntFunction(node, 'sub', 'always', true, unsafe, implicitsFn, ast);
}
