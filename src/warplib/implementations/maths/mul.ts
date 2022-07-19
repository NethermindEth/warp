import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import {
  generateFile,
  forAllWidths,
  uint256,
  pow2,
  bound,
  mask,
  msb,
  IntxIntFunction,
} from '../../utils';

export function mul(): void {
  generateFile(
    'mul',
    [
      'from starkware.cairo.common.uint256 import Uint256, uint256_mul',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from warplib.maths.ge import warp_ge256',
      'from warplib.maths.utils import felt_to_uint256',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_mul256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):',
          '    let (result : Uint256, overflow : Uint256) = uint256_mul(lhs, rhs)',
          '    assert overflow.low = 0',
          '    assert overflow.high = 0',
          '    return (result)',
          'end',
        ];
      } else if (width >= 128) {
        return [
          `func warp_mul${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          '    alloc_locals',
          '    let (l256 : Uint256) = felt_to_uint256(lhs.value)',
          '    let (r256 : Uint256) = felt_to_uint256(rhs.value)',
          '    let (local res : Uint256) = warp_mul256(l256, r256)',
          `    let (outOfRange : felt) = warp_ge256(res, ${uint256(pow2(width))})`,
          '    assert outOfRange = 0',
          `    return (Uint${width}(value=res.low + ${bound(128)} * res.high))`,
          'end',
        ];
      } else {
        return [
          `func warp_mul${width}{range_check_ptr}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          '    let res = lhs.value * rhs.value',
          `    let (inRange : felt) = is_le_felt(res, ${mask(width)})`,
          '    assert inRange = 1',
          `    return (Uint${width}(value = res))`,
          'end',
        ];
      }
    }),
  );
}

export function mul_unsafe(): void {
  generateFile(
    'mul_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_mul',
      'from warplib.maths.utils import felt_to_uint256',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_mul_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          `    let (res : Uint256, _) = uint256_mul(lhs, rhs)`,
          `    return (res)`,
          `end`,
        ];
      } else if (width >= 128) {
        return [
          `func warp_mul_unsafe${width}{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    alloc_locals`,
          `    let (l256 : Uint256) = felt_to_uint256(lhs.value)`,
          `    let (r256 : Uint256) = felt_to_uint256(rhs.value)`,
          `    let (local res : Uint256, _) = uint256_mul(l256, r256)`,
          `    let (high) = bitwise_and(res.high, ${mask(width - 128)})`,
          `    return (Uint${width}(value=res.low + ${bound(128)} * high))`,
          `end`,
        ];
      } else {
        return [
          `func warp_mul_unsafe${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    let (trunc_res) = bitwise_and(lhs.value * rhs.value, ${mask(width)})`,
          `    return (Uint${width}(value = trunc_res))`,
          'end',
        ];
      }
    }),
  );
}

export function mul_signed(): void {
  generateFile(
    'mul_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_cond_neg, uint256_signed_nn, uint256_neg, uint256_le',
      'from warplib.maths.utils import felt_to_uint256',
      `from warplib.maths.le import ${mapRange(32, (n) => `warp_le${8 * n + 8}`)}`,
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.maths.int_conversions import ${mapRange(32, (n) => [
        `warp_int${8 * n + 8}_to_uint${8 * n + 8}`,
        `warp_uint${8 * n + 8}_to_int${8 * n + 8}`,
      ])}`,
      `from warplib.maths.mul import ${mapRange(31, (n) => `warp_mul${8 * n + 8}`).join(', ')}`,
      `from warplib.maths.negate import ${mapRange(31, (n) => [`warp_negate${8 * n + 8}`]).join(
        ', ',
      )}`,

      `from warplib.maths.negate_signed import ${mapRange(31, (n) => [
        `warp_negate_signed${8 * n + 8}`,
      ]).join(', ')}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_mul_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `    lhs : Int256, rhs : Int256) -> (result : Int256):`,
          `    alloc_locals`,
          `    # 1 => lhs >= 0, 0 => lhs < 0`,
          `    let (lhs_nn) = uint256_signed_nn(lhs.value)`,
          `    # 1 => rhs >= 0, 0 => rhs < 0`,
          `    let (local rhs_nn) = uint256_signed_nn(rhs.value)`,
          `    # negates if arg is 1, which is if lhs_nn is 0, which is if lhs < 0`,
          `    let (lhs_abs) = uint256_cond_neg(lhs.value, 1 - lhs_nn)`,
          `    # negates if arg is 1`,
          `    let (rhs_abs) = uint256_cond_neg(rhs.value, 1 - rhs_nn)`,
          `    let (res_abs, overflow) = uint256_mul(lhs_abs, rhs_abs)`,
          `    assert overflow.low = 0`,
          `    assert overflow.high = 0`,
          `    let res_should_be_neg = lhs_nn + rhs_nn`,
          `    if res_should_be_neg == 1:`,
          `        let (in_range) = uint256_le(res_abs, Uint256(0,${msb(128)}))`,
          `        assert in_range = 1`,
          `        let (negated) = uint256_neg(res_abs)`,
          `        return (Int256(value=negated))`,
          `    else:`,
          `        let (msb) = bitwise_and(res_abs.high, ${msb(128)})`,
          `        assert msb = 0`,
          `        return (Int256(value=res_abs))`,
          `    end`,
          `end`,
        ];
      } else {
        return [
          `func warp_mul_signed${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    alloc_locals`,
          `    let (left_msb) = bitwise_and(lhs.value, ${msb(width)})`,
          `    if left_msb == 0:`,
          `        let (right_msb) = bitwise_and(rhs.value, ${msb(width)})`,
          `        if right_msb == 0:`,
          `            let (ulhs) = warp_int${width}_to_uint${width}(lhs)`,
          `            let (urhs) = warp_int${width}_to_uint${width}(rhs)`,
          `            let (res) = warp_mul${width}(ulhs, urhs)`,
          `            let (res_msb) = bitwise_and(res.value, ${msb(width)})`,
          `            assert res_msb = 0`,
          `            let (res_int) = warp_uint${width}_to_int${width}(res)`,
          `            return (res_int)`,
          `        else:`,
          `            let (rhs_abs) = warp_negate_signed${width}(rhs)`,
          `            let (ulhs) = warp_int${width}_to_uint${width}(lhs)`,
          `            let (urhs_abs) = warp_int${width}_to_uint${width}(rhs_abs)`,
          `            let (res_abs) = warp_mul${width}(ulhs, urhs_abs)`,
          `            let (in_range) = warp_le${width}(res_abs, Uint${width}(value=${msb(
            width,
          )}))`,
          `            assert in_range = 1`,
          `            let (res) = warp_negate${width}(res_abs)`,
          `            let (res_int) = warp_uint${width}_to_int${width}(res)`,
          `            return (res_int)`,
          `        end`,
          `    else:`,
          `        let (right_msb) = bitwise_and(rhs.value, ${msb(width)})`,
          `        if right_msb == 0:`,
          `            let (lhs_abs) = warp_negate_signed${width}(lhs)`,
          `            let (urhs) = warp_int${width}_to_uint${width}(rhs)`,
          `            let (ulhs_abs) = warp_int${width}_to_uint${width}(lhs_abs)`,
          `            let (res_abs) = warp_mul${width}(ulhs_abs, urhs)`,
          `            let (in_range) = warp_le${width}(res_abs, Uint${width}(value=${msb(
            width,
          )}))`,
          `            assert in_range = 1`,
          `            let (res) = warp_negate${width}(res_abs)`,
          `            let (res_int) = warp_uint${width}_to_int${width}(res)`,
          `            return (res_int)`,
          `        else:`,
          `            let (lhs_abs) = warp_negate_signed${width}(lhs)`,
          `            let (rhs_abs) = warp_negate_signed${width}(rhs)`,
          `            let (ulhs_abs) = warp_int${width}_to_uint${width}(lhs_abs)`,
          `            let (urhs_abs) = warp_int${width}_to_uint${width}(rhs_abs)`,
          `            let (res) = warp_mul${width}(ulhs_abs, urhs_abs)`,
          `            let (res_msb) = bitwise_and(res.value, ${msb(width)})`,
          `            assert res_msb = 0`,
          `            let (res_int) = warp_uint${width}_to_int${width}(res)`,
          `            return (res_int)`,
          `        end`,
          `    end`,
          `end`,
        ];
      }
    }),
  );
}

export function mul_signed_unsafe(): void {
  generateFile(
    'mul_signed_unsafe',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_cond_neg, uint256_signed_nn',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      `from warplib.maths.int_conversions import ${mapRange(32, (n) => [
        `warp_int${8 * n + 8}_to_uint${8 * n + 8}`,
        `warp_uint${8 * n + 8}_to_int${8 * n + 8}`,
      ])}`,
      `from warplib.maths.mul_unsafe import ${mapRange(
        31,
        (n) => `warp_mul_unsafe${8 * n + 8}`,
      ).join(', ')}`,
      `from warplib.maths.negate import ${mapRange(31, (n) => [`warp_negate${8 * n + 8}`]).join(
        ', ',
      )}`,

      `from warplib.maths.negate_signed import ${mapRange(31, (n) => [
        `warp_negate_signed${8 * n + 8}`,
      ]).join(', ')}`,
      'from warplib.maths.utils import felt_to_uint256',
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_mul_signed_unsafe256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `    lhs : Int256, rhs : Int256) -> (result : Int256):`,
          `    alloc_locals`,
          `    let (lhs_nn) = uint256_signed_nn(lhs.value)`,
          `    let (local rhs_nn) = uint256_signed_nn(rhs.value)`,
          `    let (lhs_abs) = uint256_cond_neg(lhs.value, lhs_nn)`,
          `    let (rhs_abs) = uint256_cond_neg(rhs.value, rhs_nn)`,
          `    let (res_abs, _) = uint256_mul(lhs_abs, rhs_abs)`,
          `    let (res) = uint256_cond_neg(res_abs, (lhs_nn + rhs_nn) * (2 - lhs_nn - rhs_nn))`,
          `    return (Int256(value=res))`,
          `end`,
        ];
      } else {
        return [
          `func warp_mul_signed_unsafe${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    alloc_locals`,
          `    let (local left_msb) = bitwise_and(lhs.value, ${msb(width)})`,
          `    let (local right_msb) = bitwise_and(rhs.value, ${msb(width)})`,
          `    let (ulhs) = warp_int${width}_to_uint${width}(lhs)`,
          `    let (urhs) = warp_int${width}_to_uint${width}(rhs)`,
          `    let (res) = warp_mul_unsafe${width}(ulhs, urhs)`,
          `    let neg = (left_msb + right_msb) * (${bound(width)} - left_msb - right_msb)`,
          `    if neg == 0:`,
          `        let (res_int) = warp_uint${width}_to_int${width}(res)`,
          `        return (res_int)`,
          `    else:`,
          `        let (res) = warp_negate${width}(res)`,
          `        let (res_int) = warp_uint${width}_to_int${width}(res)`,
          `        return (res_int)`,
          `    end`,
          `end`,
        ];
      }
    }),
  );
}

export function functionaliseMul(node: BinaryOperation, unsafe: boolean, ast: AST): void {
  const implicitsFn = (width: number, signed: boolean): Implicits[] => {
    if (signed || (unsafe && width >= 128 && width < 256))
      return ['range_check_ptr', 'bitwise_ptr'];
    else if (unsafe && width < 128) return ['bitwise_ptr'];
    else return ['range_check_ptr'];
  };
  IntxIntFunction(node, 'mul', 'always', true, unsafe, implicitsFn, ast);
}
