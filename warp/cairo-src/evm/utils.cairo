from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le

func get_max{range_check_ptr}(op1, op2) -> (result):
    let (le) = is_le(op1, op2)
    if le == 1:
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

func update_msize{range_check_ptr}(size, offset, length) -> (result):
    # Update MSIZE on memory access from 'offset' to 'offset +
    # length', according to the rules specified in the yellow paper.
    if length == 0:
        return (size)
    end

    let (result) = get_max(size, offset + length)
    return (result)
end

func round_down_to_multiple{range_check_ptr}(x, div) -> (y):
    let (r) = floor_div(x, div)
    return (r * div)
end

func round_up_to_multiple{range_check_ptr}(x, div) -> (y):
    let (r) = ceil_div(x, div)
    return (r * div)
end
