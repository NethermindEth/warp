from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem
from warplib.maths.utils import felt_to_uint256

const SHIFT = 2 ** 128

func warp_div{range_check_ptr}(lhs : felt, rhs : felt) -> (res : felt):
    let (lhs_256) = felt_to_uint256(lhs)
    let (rhs_256) = felt_to_uint256(rhs)
    let (res256, _) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    return (res256.low + SHIFT * res256.high)
end

func warp_div256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):
    let (res : Uint256, _) = uint256_unsigned_div_rem(lhs, rhs)
    return (res)
end
