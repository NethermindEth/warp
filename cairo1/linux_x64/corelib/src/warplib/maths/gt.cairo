from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_le

func warp_gt{range_check_ptr}(lhs: felt, rhs: felt) -> (res: felt) {
    if (lhs == rhs) {
        return (0,);
    }
    let res = is_le_felt(rhs, lhs);
    return (res,);
}

func warp_gt256{range_check_ptr}(lhs: Uint256, rhs: Uint256) -> (res: felt) {
    let (le) = uint256_le(lhs, rhs);
    return (1 - le,);
}
