from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_le

func warp_le{range_check_ptr}(lhs: felt, rhs: felt) -> (res: felt) {
    let res = is_le_felt(lhs, rhs);
    return (res,);
}

func warp_le256{range_check_ptr}(lhs: Uint256, rhs: Uint256) -> (result: felt) {
    let (res) = uint256_le(lhs, rhs);
    return (res,);
}
