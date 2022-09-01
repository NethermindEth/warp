from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_unsigned_div_rem
from warplib.maths.pow2 import pow2, u256_pow2
from warplib.maths.utils import felt_to_uint256
from starkware.cairo.common.bitwise import bitwise_and, bitwise_not
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

const SHIFT = 2 ** 128;

func warp_bytes_widen(x: felt, widthDiff: felt) -> (res: felt) {
    let (multiplier) = pow2(widthDiff);
    return (x * multiplier,);
}

func warp_bytes_widen_256{range_check_ptr}(x: felt, widthDiff: felt) -> (res: Uint256) {
    let (in256: Uint256) = felt_to_uint256(x);
    let (multiplier) = u256_pow2(widthDiff);
    let (res, overflow) = uint256_mul(in256, multiplier);
    assert overflow.low = 0;
    assert overflow.high = 0;
    return (res,);
}

func warp_bytes_narrow{bitwise_ptr: BitwiseBuiltin*}(x: felt, widthDiff: felt) -> (res: felt) {
    let (divisor) = pow2(widthDiff);
    let (mask) = bitwise_not(divisor - 1);
    let (res) = bitwise_and(x, mask);
    return (res / divisor,);
}

func warp_bytes_narrow_256{range_check_ptr: felt}(x: Uint256, widthDiff: felt) -> (res: felt) {
    let (divisor_felt) = pow2(widthDiff);
    let (divisor) = felt_to_uint256(divisor_felt);
    let (res, _) = uint256_unsigned_div_rem(x, divisor);
    return (SHIFT * res.high + res.low,);
}
