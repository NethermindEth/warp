from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem, uint256_add, uint256_mul, uint256_sub, ALL_ONES
from warplib.maths.utils import felt_to_uint256
from warplib.maths.addmod import warp_addmod256

const SHIFT = 2 ** 128

func warp_mulmod{range_check_ptr}(x : felt, y : felt, k : felt) -> (res : felt):
    let (x_256) = felt_to_uint256(x)
    let (y_256) = felt_to_uint256(y)
    let (k_256) = felt_to_uint256(k)

    let (res256) = warp_mulmod256(x_256, y_256, k_256)

    return (res256.low + SHIFT * res256.high)
end

func warp_mulmod256{range_check_ptr}(x : Uint256, y : Uint256, k : Uint256) -> (res : Uint256):
    alloc_locals
    if k.high + k.low == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end

    let (xy_low, xy_high) = uint256_mul(x, y)
    if xy_high.low + xy_high.high == 0:
        let (_, res) = uint256_unsigned_div_rem(xy_low, k)
        return (res)
    end

    let uint256_MAX = Uint256(low=ALL_ONES, high=ALL_ONES)
    let (_, exp_mod_k) = uint256_unsigned_div_rem(uint256_MAX, k)
    let (exp_mod_k, _) = uint256_add(exp_mod_k, Uint256(1, 0))
    let (_, exp_mod_k) = uint256_unsigned_div_rem(exp_mod_k, k)

    let (_, xy_high_mod_k) = uint256_unsigned_div_rem(xy_high, k)
    let (_, xy_low_mod_k) = uint256_unsigned_div_rem(xy_low, k)

    let (xy_high_exp_mod_k) = warp_mulmod256(exp_mod_k, xy_high_mod_k, k)
    let (res) = warp_addmod256(xy_high_exp_mod_k, xy_low_mod_k, k)

    return (res)
end
