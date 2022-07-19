import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { forAllWidths, generateFile, IntxIntFunction, mask } from '../../utils';

export function div() {
  generateFile(
    'div',
    [
      `from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.maths.int_conversions import ${mapRange(
        31,
        (n) => `warp_uint${8 * n + 8}_to_uint256`,
      ).join(', ')}`,
      ``,
      `const SHIFT = 2 ** 128`,
    ],
    forAllWidths((width) => {
      if (width == 256) {
        return [
          `func warp_div256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    if rhs.high == 0:`,
          `        if rhs.low == 0:`,
          `            with_attr error_message("Division by zero error"):`,
          `                assert 1 = 0`,
          `            end`,
          `        end`,
          `    end`,
          `    let (res : Uint256, _) = uint256_unsigned_div_rem(lhs, rhs)`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_div${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    if rhs.value == 0:`,
          `        with_attr error_message("Division by zero error"):`,
          `            assert 1 = 0`,
          `        end`,
          `    end`,
          `    let (lhs_256) = warp_uint${width}_to_uint256(lhs)`,
          `    let (rhs_256) = warp_uint${width}_to_uint256(rhs)`,
          `    let (res256, _) = uint256_unsigned_div_rem(lhs_256, rhs_256)`,
          `    let res_felt = res256.low + SHIFT * res256.high`,
          `    return (Uint${width}(value = res_felt))`,
          `end`,
        ];
      }
    }),
  );
}

export function div_signed() {
  generateFile(
    'div_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_div_rem, uint256_eq',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.maths.int_conversions import ${mapRange(
        31,
        (n) => `warp_int${8 * n + 8}_to_uint256`,
      ).join(', ')}, ${mapRange(31, (n) => `warp_uint256_to_int${8 * n + 8}`).join(', ')}`,
      `from warplib.maths.mul_signed import ${mapRange(32, (n) => `warp_mul_signed${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_div_signed256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : Int256, rhs : Int256) -> (res : Int256):',
          `    if rhs.value.high == 0:`,
          `       if rhs.value.low == 0:`,
          `           with_attr error_message("Division by zero error"):`,
          `             assert 1 = 0`,
          `           end`,
          `       end`,
          `    end`,
          `    let (is_minus_one) = uint256_eq(rhs.value, Uint256(${mask(128)}, ${mask(128)}))`,
          `    if is_minus_one == 1:`,
          '        let (res : Int256) = warp_mul_signed256(lhs, rhs)',
          '        return (res)',
          '    end',
          '    let (ures : Uint256, _) = uint256_signed_div_rem(lhs.value, rhs.value)',
          '    return (Int256(value=ures))',
          'end',
        ];
      } else {
        return [
          `func warp_div_signed${width}{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    alloc_locals`,
          `    if rhs.value == 0:`,
          `        with_attr error_message("Division by zero error"):`,
          `            assert 1 = 0`,
          `        end`,
          `    end`,
          `    if rhs.value == ${mask(width)}:`,
          `        let (res : Int${width}) = warp_mul_signed${width}(lhs, rhs)`,
          `        return (res)`,
          '    end',
          `    let (local lhs_256) = warp_int${width}_to_uint256(lhs)`,
          `    let (rhs_256) = warp_int${width}_to_uint256(rhs)`,
          '    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256)',
          `    let (truncated) = warp_uint256_to_int${width}(res256)`,
          `    return (truncated)`,
          'end',
        ];
      }
    }),
  );
}

export function div_unsafe() {
  generateFile(
    'div_unsafe',
    [
      `from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.maths.int_conversions import ${mapRange(
        31,
        (n) => `warp_uint${8 * n + 8}_to_uint256`,
      ).join(', ')}`,
      ``,
      `const SHIFT = 2 ** 128`,
    ],
    forAllWidths((width) => {
      if (width == 256) {
        return [
          `func warp_div_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    if rhs.high == 0:`,
          `        if rhs.low == 0:`,
          `            with_attr error_message("Division by zero error"):`,
          `                assert 1 = 0`,
          `            end`,
          `        end`,
          `    end`,
          `    let (res : Uint256, _) = uint256_unsigned_div_rem(lhs, rhs)`,
          `    return (res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_div_unsafe${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    if rhs.value == 0:`,
          `        with_attr error_message("Division by zero error"):`,
          `            assert 1 = 0`,
          `        end`,
          `    end`,
          `    let (lhs_256) = warp_uint${width}_to_uint256(lhs)`,
          `    let (rhs_256) = warp_uint${width}_to_uint256(rhs)`,
          `    let (res256, _) = uint256_unsigned_div_rem(lhs_256, rhs_256)`,
          `    let res_felt = res256.low + SHIFT * res256.high`,
          `    return (Uint${width}(value = res_felt))`,
          `end`,
        ];
      }
    }),
  );
}

export function div_signed_unsafe() {
  generateFile(
    'div_signed_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_div_rem, uint256_eq',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.maths.int_conversions import ${mapRange(
        31,
        (n) => `warp_int${8 * n + 8}_to_uint256`,
      ).join(', ')}, ${mapRange(31, (n) => `warp_uint256_to_int${8 * n + 8}`).join(', ')}`,
      `from warplib.maths.mul_signed_unsafe import ${mapRange(
        32,
        (n) => `warp_mul_signed_unsafe${8 * n + 8}`,
      )}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_div_signed_unsafe256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : Int256, rhs : Int256) -> (res : Int256):',
          `    if rhs.value.high == 0:`,
          `       if rhs.value.low == 0:`,
          `           with_attr error_message("Division by zero error"):`,
          `             assert 1 = 0`,
          `           end`,
          `       end`,
          `    end`,
          `    let (is_minus_one) = uint256_eq(rhs.value, Uint256(${mask(128)}, ${mask(128)}))`,
          `    if is_minus_one == 1:`,
          '        let (res : Int256) = warp_mul_signed_unsafe256(lhs, rhs)',
          '        return (res)',
          '    end',
          '    let (ures : Uint256, _) = uint256_signed_div_rem(lhs.value, rhs.value)',
          '    return (Int256(value=ures))',
          'end',
        ];
      } else {
        return [
          `func warp_div_signed_unsafe${width}{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    alloc_locals`,
          `    if rhs.value == 0:`,
          `        with_attr error_message("Division by zero error"):`,
          `            assert 1 = 0`,
          `        end`,
          `    end`,
          `    if rhs.value == ${mask(width)}:`,
          `        let (res : Int${width}) = warp_mul_signed_unsafe${width}(lhs, rhs)`,
          `        return (res)`,
          '    end',
          `    let (local lhs_256) = warp_int${width}_to_uint256(lhs)`,
          `    let (rhs_256) = warp_int${width}_to_uint256(rhs)`,
          '    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256)',
          `    let (truncated) = warp_uint256_to_int${width}(res256)`,
          `    return (truncated)`,
          'end',
        ];
      }
    }),
  );
}

export function functionaliseDiv(node: BinaryOperation, unsafe: boolean, ast: AST): void {
  const implicitsFn = (width: number, signed: boolean): Implicits[] => {
    if (signed || (unsafe && width >= 128 && width < 256))
      return ['range_check_ptr', 'bitwise_ptr'];
    else if (unsafe && width < 128) return ['bitwise_ptr'];
    else return ['range_check_ptr'];
  };
  IntxIntFunction(node, 'div', 'always', true, unsafe, implicitsFn, ast);
}
