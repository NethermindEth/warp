from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le

func get_max{range_check_ptr}(op1, op2) -> (result):
    is_le(op1, op2)
    if [ap - 1] == 1:
        return (op2)
    else:
        return (op1)
    end
end

func floor_div{range_check_ptr}(a, b) -> (res):
    let (q, _) = unsigned_div_rem(a, b)
    return (q)
end

func ceil_div{range_check_ptr}(a, b) -> (res):
    let (q, r) = unsigned_div_rem(a, b)
    if r == 0:
        return (q)
    else:
        return (q + 1)
    end
end

func round_down_to_multiple{range_check_ptr}(x, div) -> (y):
    floor_div(x, div)
    return ([ap - 1] * div)
end

func round_up_to_multiple{range_check_ptr}(x, div) -> (y):
    ceil_div(x, div)
    return ([ap - 1] * div)
end
