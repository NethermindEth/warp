import assert from 'assert';
import { BinaryOperation, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printTypeNode } from '../../../utils/astPrinter';
import { Implicits } from '../../../utils/implicits';
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
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_sub_unsafe256{bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (`,
          `        result : Uint256){`,
          '    //preemptively borrow from bit128',
          `    let (low_safe) = bitwise_and(${bound(128)} + lhs.low - rhs.low, ${mask(128)});`,
          `    let low_unsafe = lhs.low - rhs.low;`,
          `    if (low_safe == low_unsafe){`,
          '        //the borrow was not used',
          `        let (high) = bitwise_and(${bound(128)} + lhs.high - rhs.high, ${mask(128)});`,
          `        return (Uint256(low_safe, high),);`,
          `    }else{`,
          '        //the borrow was used',
          `        let (high) = bitwise_and(${bound(128)} + lhs.high - rhs.high - 1, ${mask(
            128,
          )});`,
          `        return (Uint256(low_safe, high),);`,
          `    }`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func warp_sub_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt){`,
          `    let res : felt = ${bound(width)} + lhs - rhs;`,
          `    let (res) = bitwise_and(res, ${mask(width)});`,
          `    return (res,);`,
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
          `    let (left_msb : felt) = bitwise_and(lhs.high, ${msb(128)});`,
          `    let (right_msb : felt) = bitwise_and(rhs.high, ${msb(128)});`,
          `    let left_overflow : felt = left_msb / ${msb(128)};`,
          `    let right_overflow : felt = right_msb / ${msb(128)};`,
          ``,
          `    // Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let (right_flipped : Uint256) = uint256_not(rhs);`,
          `    let (right_neg, overflow) = uint256_add(right_flipped, Uint256(1,0));`,
          `    let right_overflow_neg = overflow + 1 - right_overflow;`,
          `    let (res, res_base_overflow) = uint256_add(lhs, right_neg);`,
          `    let res_overflow = res_base_overflow + left_overflow + right_overflow_neg;`,
          ``,
          `    // Check if the result fits in the correct width`,
          `    let (res_msb : felt) = bitwise_and(res.high, ${msb(128)});`,
          `    let (res_overflow_lsb : felt) = bitwise_and(res_overflow, 1);`,
          `    assert res_overflow_lsb * ${msb(128)} = res_msb;`,
          ``,
          `    // Narrow and return`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func warp_sub_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt){`,
          `    // First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs, ${msb(width)});`,
          `    let (right_msb : felt) = bitwise_and(rhs, ${msb(width)});`,
          `    let left_safe : felt = lhs + 2 * left_msb;`,
          `    let right_safe : felt = rhs + 2 * right_msb;`,
          ``,
          `    // Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt = ${bound(width + 1)} - right_safe;`,
          `    let extended_res : felt = left_safe + right_neg;`,
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
          `        lhs : felt, rhs : felt) -> (res : felt){`,
          `    // First sign extend both operands`,
          `    let (left_msb : felt) = bitwise_and(lhs, ${msb(width)});`,
          `    let (right_msb : felt) = bitwise_and(rhs, ${msb(width)});`,
          `    let left_safe : felt = lhs + 2 * left_msb;`,
          `    let right_safe : felt = rhs + 2 * right_msb;`,
          ``,
          `    // Now safely negate the rhs and add (l - r = l + (-r))`,
          `    let right_neg : felt = ${bound(width + 1)} - right_safe;`,
          `    let extended_res : felt = left_safe + right_neg;`,
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
  const typeNode = safeGetNodeType(node, ast.inference);
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
