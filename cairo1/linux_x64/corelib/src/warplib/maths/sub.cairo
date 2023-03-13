from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_le

func warp_sub{range_check_ptr}(lhs: felt, rhs: felt) -> (res: felt) {
    let valid = is_le_felt(rhs, lhs);
    assert valid = 1;
    return (lhs - rhs,);
}

const MASK128 = 2 ** 128 - 1;
const BOUND128 = 2 ** 128;

func warp_sub256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs: Uint256, rhs: Uint256) -> (
    res: Uint256
) {
    let (safe) = uint256_le(rhs, lhs);
    assert safe = 1;
    // preemptively borrow from bit128
    let (low_safe) = bitwise_and(BOUND128 + lhs.low - rhs.low, MASK128);
    let low_unsafe = lhs.low - rhs.low;
    if (low_safe == low_unsafe) {
        // the borrow was not used
        return (Uint256(low_safe, lhs.high - rhs.high),);
    } else {
        // the borrow was used
        return (Uint256(low_safe, lhs.high - rhs.high - 1),);
    }
}
