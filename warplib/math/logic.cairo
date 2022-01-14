from starkware.cairo.common.math_cmp import is_le

func felt_eq(lhs: felt, rhs: felt) -> (result: felt):
    if lhs == rhs:
        return (result = 1)
    else:
        return (result = 0)
    end
end

func felt_gt{range_check_ptr : felt}(lhs : felt, rhs : felt) -> (result : felt):
    return is_le(rhs, lhs)
end

func felt_and(lhs: felt, rhs: felt) -> (result: felt):
    return (result = lhs * rhs)
end
