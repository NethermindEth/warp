from starkware.cairo.common.uint256 import Uint256, uint256_mul
from warplib.maths.pow2 import pow2, u256_pow2
from warplib.maths.utils import felt_to_uint256

func warp_bytes_widen(x: felt, widthDiff: felt) -> (res: felt):
    let (multiplier) = pow2(widthDiff)
    return (x*multiplier)
end

func warp_bytes_widen_256{range_check_ptr}(x: felt, widthDiff: felt) -> (res: Uint256):
    let (in256: Uint256) = felt_to_uint256(x)
    let (multiplier) = u256_pow2(widthDiff)
    let (res, overflow) = uint256_mul(in256, multiplier)
    assert overflow.low = 0
    assert overflow.high = 0
    return (res)
end