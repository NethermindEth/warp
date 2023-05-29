from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_unsigned_div_rem,
    uint256_add,
    uint256_sub,
    ALL_ONES,
)
from warplib.maths.utils import felt_to_uint256

const SHIFT = 2 ** 128;

func warp_addmod{range_check_ptr}(x: Uint256, y: Uint256, k: Uint256) -> (res: Uint256) {
    alloc_locals;
    if (k.high + k.low == 0) {
        with_attr error_message("Modulo by zero error") {
            assert 1 = 0;
        }
    }

    let (xy, carry) = uint256_add(x, y);
    if (carry == 0) {
        let (_, res: Uint256) = uint256_unsigned_div_rem(xy, k);
        return (res,);
    }

    let uint256_MAX = Uint256(low=ALL_ONES, high=ALL_ONES);
    let (overflow) = uint256_sub(uint256_MAX, k);
    // carry is zero because k > 0
    let (overflow, _) = uint256_add(overflow, Uint256(low=1, high=0));
    let (_, overflow_rem) = uint256_unsigned_div_rem(overflow, k);

    let (_, xy_rem) = uint256_unsigned_div_rem(xy, k);

    let (res_, _) = uint256_add(xy_rem, overflow_rem);

    let (_, res) = uint256_unsigned_div_rem(res_, k);

    return (res,);
}
