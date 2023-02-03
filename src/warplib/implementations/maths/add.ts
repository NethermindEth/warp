import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import {
  forAllWidths,
  IntxIntFunction,
  mask,
  msb,
  msbAndNext,
  WarplibFunctionInfo,
} from '../../utils';

export function add(): WarplibFunctionInfo {
  const fileName = 'add';
  const imports = [
    'from starkware.cairo.common.math_cmp import is_le_felt',
    'from starkware.cairo.common.uint256 import Uint256, uint256_add',
  ];
  const functions = forAllWidths((width) => {
    if (width === 256) {
      return [
        `func warp_add256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){`,
        `    let (res : Uint256, carry : felt) = uint256_add(lhs, rhs);`,
        `    assert carry = 0;`,
        `    return (res,);`,
        `}`,
      ].join('\n');
    } else {
      return [
        `func warp_add${width}{range_check_ptr}(lhs : felt, rhs : felt) -> (res : felt){`,
        `    let res = lhs + rhs;`,
        `    let inRange : felt = is_le_felt(res, ${mask(width)});`,
        `    assert inRange = 1;`,
        `    return (res,);`,
        `}`,
      ].join('\n');
    }
  });

  return { fileName, imports, functions };
}

export function add_unsafe(): WarplibFunctionInfo {
  return {
    fileName: 'add_unsafe',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){`,
          `    let (res : Uint256, _) = uint256_add(lhs, rhs);`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func warp_add_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt){`,
          `    let (res) = bitwise_and(lhs + rhs, ${mask(width)});`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function add_signed(): WarplibFunctionInfo {
  return {
    fileName: 'add_signed',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Uint256, rhs : Uint256) -> (res : Uint256){`,
          `    let (lhs_extend) = bitwise_and(lhs.high, ${msb(128)});`,
          `    let (rhs_extend) = bitwise_and(rhs.high, ${msb(128)});`,
          `    let (res : Uint256, carry : felt) = uint256_add(lhs, rhs);`,
          `    let carry_extend = lhs_extend + rhs_extend + carry*${msb(128)};`,
          `    let (msb) = bitwise_and(res.high, ${msb(128)});`,
          `    let (carry_lsb) = bitwise_and(carry_extend, ${msb(128)});`,
          `    assert msb = carry_lsb;`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func warp_add_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (`,
          `        res : felt){`,
          `// Do the addition sign extended`,
          `    let (lmsb) = bitwise_and(lhs, ${msb(width)});`,
          `    let (rmsb) = bitwise_and(rhs, ${msb(width)});`,
          `    let big_res = lhs + rhs + 2*(lmsb+rmsb);`,
          `// Check the result is valid`,
          `    let (overflowBits) = bitwise_and(big_res,  ${msbAndNext(width)});`,
          `    assert overflowBits * (overflowBits - ${msbAndNext(width)}) = 0;`,
          `// Truncate and return`,
          `    let (res) =  bitwise_and(big_res, ${mask(width)});`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function add_signed_unsafe(): WarplibFunctionInfo {
  return {
    fileName: 'add_signed_unsafe',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_add_signed_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){`,
          `    let (res : Uint256, _) = uint256_add(lhs, rhs);`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func warp_add_signed_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : felt, rhs : felt) -> (res : felt){`,
          `    let (res) = bitwise_and(lhs + rhs, ${mask(width)});`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function functionaliseAdd(node: BinaryOperation, unsafe: boolean, ast: AST): void {
  IntxIntFunction(node, 'add', 'always', true, unsafe, ast);
}
