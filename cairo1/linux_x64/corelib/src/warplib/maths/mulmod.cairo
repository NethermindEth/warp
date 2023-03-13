from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_unsigned_div_rem,
    uint256_add,
    uint256_mul,
    uint256_sub,
    ALL_ONES,
)
from warplib.maths.utils import felt_to_uint256
from warplib.maths.addmod import warp_addmod

func warp_mulmod{range_check_ptr}(x: Uint256, y: Uint256, k: Uint256) -> (res: Uint256) {
    alloc_locals;
    if (k.high + k.low == 0) {
        with_attr error_message("Modulo by zero error") {
            assert 1 = 0;
        }
    }

    let (xy_low, xy_high) = uint256_mul(x, y);
    if (xy_high.low + xy_high.high == 0) {
        let (_, res) = uint256_unsigned_div_rem(xy_low, k);
        return (res,);
    }

    let uint256_MAX = Uint256(low=ALL_ONES, high=ALL_ONES);
    let (_, exp_mod_k) = uint256_unsigned_div_rem(uint256_MAX, k);
    let (exp_mod_k, _) = uint256_add(exp_mod_k, Uint256(1, 0));
    let (_, exp_mod_k) = uint256_unsigned_div_rem(exp_mod_k, k);

    let (_, xy_high_mod_k) = uint256_unsigned_div_rem(xy_high, k);
    let (_, xy_low_mod_k) = uint256_unsigned_div_rem(xy_low, k);

    let (xy_high_exp_mod_k) = warp_mulmod(exp_mod_k, xy_high_mod_k, k);
    let (res) = warp_addmod(xy_high_exp_mod_k, xy_low_mod_k, k);

    return (res,);
}
