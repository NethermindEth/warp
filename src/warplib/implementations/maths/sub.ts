import assert from 'assert';
import { BinaryOperation, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printTypeNode } from '../../../utils/astPrinter';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import {
  forAllWidths,
  bound,
  mask,
  msb,
  msbAndNext,
  IntxIntFunction,
  WarplibFunctionInfo,
} from '../../utils';

export function sub_unsafe(): WarplibFunctionInfo {
  return {
    fileName: 'sub_unsafe',
    imports: ['use integer::u256_overflow_sub;'],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `fn warp_sub_unsafe256(lhs : u256, rhs : u256) -> u256 {`,
          `    let (value, _) = u256_overflow_sub(lhs, rhs);`,
          `    return value;`,
          `}`,
        ].join('\n');
      } else {
        return [
          // TODO: Use bitwise '&' to take just the width-bits
          `fn warp_sub_unsafe${width}(lhs : felt252, rhs : felt252) -> felt252 {`,
          `    return lhs - rhs;`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function sub_signed(): WarplibFunctionInfo {
  return {
    fileName: 'sub_signed',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_signed_le, uint256_sub, uint256_not',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_sub_signed${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (`,
          `        res : Uint256){`,
          `    // First sign extend both operands`,
          `    let (left_msb : felt252) = bitwise_and(lhs.high, ${msb(128)});`,
          `    let (right_msb : felt252) = bitwise_and(rhs.high, ${msb(128)});`,
          `    let left_overflow : felt252 = left_msb / ${msb(128)};`,
          `    let right_overflow : felt252 = right_msb / ${msb(128)};`,
          ``,
          `    // Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let (right_flipped : Uint256) = uint256_not(rhs);`,
          `    let (right_neg, overflow) = uint256_add(right_flipped, Uint256(1,0));`,
          `    let right_overflow_neg = overflow + 1 - right_overflow;`,
          `    let (res, res_base_overflow) = uint256_add(lhs, right_neg);`,
          `    let res_overflow = res_base_overflow + left_overflow + right_overflow_neg;`,
          ``,
          `    // Check if the result fits in the correct width`,
          `    let (res_msb : felt252) = bitwise_and(res.high, ${msb(128)});`,
          `    let (res_overflow_lsb : felt252) = bitwise_and(res_overflow, 1);`,
          `    assert res_overflow_lsb * ${msb(128)} = res_msb;`,
          ``,
          `    // Narrow and return`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func warp_sub_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt252, rhs : felt252) -> (`,
          `        res : felt252){`,
          `    // First sign extend both operands`,
          `    let (left_msb : felt252) = bitwise_and(lhs, ${msb(width)});`,
          `    let (right_msb : felt252) = bitwise_and(rhs, ${msb(width)});`,
          `    let left_safe : felt252 = lhs + 2 * left_msb;`,
          `    let right_safe : felt252 = rhs + 2 * right_msb;`,
          ``,
          `    // Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt252 = ${bound(width + 1)} - right_safe;`,
          `    let extended_res : felt252 = left_safe + right_neg;`,
          ``,
          `    // Check if the result fits in the correct width`,
          `    let (overflowBits) = bitwise_and(extended_res, ${msbAndNext(width)});`,
          `    assert overflowBits * (overflowBits - ${msbAndNext(width)}) = 0;`,
          ``,
          `    // Narrow and return`,
          `    let (res) = bitwise_and(extended_res, ${mask(width)});`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function sub_signed_unsafe(): WarplibFunctionInfo {
  return {
    fileName: 'sub_signed_unsafe',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_sub',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_sub_signed_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){',
          '    let (res) =  uint256_sub(lhs, rhs);',
          '    return (res,);',
          '}',
        ].join('\n');
      } else {
        return [
          `func warp_sub_signed_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : felt252, rhs : felt252) -> (res : felt252){`,
          `    // First sign extend both operands`,
          `    let (left_msb : felt252) = bitwise_and(lhs, ${msb(width)});`,
          `    let (right_msb : felt252) = bitwise_and(rhs, ${msb(width)});`,
          `    let left_safe : felt252 = lhs + 2 * left_msb;`,
          `    let right_safe : felt252 = rhs + 2 * right_msb;`,
          ``,
          `    // Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt252 = ${bound(width + 1)} - right_safe;`,
          `    let extended_res : felt252 = left_safe + right_neg;`,
          ``,
          `    // Narrow and return`,
          `    let (res) = bitwise_and(extended_res, ${mask(width)});`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

//func warp_sub{range_check_ptr}(lhs : felt252, rhs : felt252) -> (res : felt252):
//func warp_sub256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):

export function functionaliseSub(node: BinaryOperation, unsafe: boolean, ast: AST): void {
  const typeNode = safeGetNodeType(node, ast.inference);
  assert(
    typeNode instanceof IntType,
    `Expected IntType for subtraction, got ${printTypeNode(typeNode)}`,
  );
  if (unsafe) {
    IntxIntFunction(node, 'sub', 'always', true, unsafe, ast);
  } else {
    IntxIntFunction(node, 'sub', 'signedOrWide', true, unsafe, ast);
  }
}
