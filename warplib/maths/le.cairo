from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_lt

func warp_le{range_check_ptr}(lhs : felt, rhs : felt) -> (res : felt):
    return is_le_felt(lhs, rhs)
end

func warp_le256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (result : felt):
    alloc_locals
    let (local lt : felt) = uint256_lt(lhs, rhs)
    let (local eq : felt) = uint256_eq(lhs, rhs)
    let result = lt + eq
    if result == 0:
        return (0)
    else:
        return (1)
    end
end
