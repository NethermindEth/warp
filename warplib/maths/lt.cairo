from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_lt

func warp_lt{range_check_ptr}(lhs: felt, rhs: felt) -> (res: felt) {
    if (lhs == rhs) {
        return (0,);
    }
    let res = is_le_felt(lhs, rhs);
    return (res,);
}

func warp_lt256{range_check_ptr}(lhs: Uint256, rhs: Uint256) -> (res: felt) {
    let (res) = uint256_lt(lhs, rhs);
    return (res,);
}
