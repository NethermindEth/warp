import assert = require('assert');
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

export function sub_unsafe(): void {
  generateFile(
    'sub_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256',
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
          `func warp_sub_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt):`,
          `    let res : felt = ${bound(width)} + lhs - rhs`,
          `    return bitwise_and(res, ${mask(width)})`,
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
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_le, uint256_sub',
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_sub_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    let (safe) = uint256_signed_le(rhs, lhs)`,
          `    assert safe = 1`,
          '    return uint256_sub(lhs, rhs)',
          `end`,
        ];
      } else {
        return [
          `func warp_sub_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt):`,
          `    # First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs, ${msb(width)})`,
          `    let (right_msb : felt) = bitwise_and(rhs, ${msb(width)})`,
          `    let left_safe : felt = lhs + 2 * left_msb`,
          `    let right_safe : felt = rhs + 2 * right_msb`,
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
          `    return bitwise_and(extended_res, ${mask(width)})`,
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
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_sub_signed_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):',
          '    return uint256_sub(lhs, rhs)',
          'end',
        ];
      } else {
        return [
          `func warp_sub_signed_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : felt, rhs : felt) -> (res : felt):`,
          `    # First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs, ${msb(width)})`,
          `    let (right_msb : felt) = bitwise_and(rhs, ${msb(width)})`,
          `    let left_safe : felt = lhs + 2 * left_msb`,
          `    let right_safe : felt = rhs + 2 * right_msb`,
          ``,
          `    # Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt = ${bound(width + 1)} - right_safe`,
          `    let extended_res : felt = left_safe + right_neg`,
          ``,
          `    # Narrow and return`,
          `    return bitwise_and(extended_res, ${mask(width)})`,
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
      if (width === 256) return ['range_check_ptr'];
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
  if (unsafe) {
    IntxIntFunction(node, 'sub', 'always', true, unsafe, implicitsFn, ast);
  } else {
    IntxIntFunction(node, 'sub', 'signedOrWide', true, unsafe, implicitsFn, ast);
  }
}
