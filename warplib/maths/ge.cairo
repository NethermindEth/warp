from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_lt

func warp_ge{range_check_ptr}(lhs: felt, rhs: felt) -> (res: felt) {
    return (is_le_felt(rhs, lhs),);
}

func warp_ge256{range_check_ptr}(op1: Uint256, op2: Uint256) -> (result: felt) {
    let (lt: felt) = uint256_lt(op1, op2);
    return (1 - lt,);
}
