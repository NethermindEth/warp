from starkware.cairo.common.math import split_felt, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le

from evm.uint256 import Uint256

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

func update_msize{range_check_ptr}(msize, offset, size) -> (result):
    # Update MSIZE on memory access from 'offset' to 'offset +
    # size', according to the rules specified in the yellow paper.
    if size == 0:
        return (msize)
    end

    let (result) = get_max(msize, offset + size)
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

func felt_to_uint256{range_check_ptr}(x) -> (x_ : Uint256):
    let split = split_felt(x)
    return (Uint256(low=split.low, high=split.high))
end

func uint256_to_address_felt(x : Uint256) -> (address : felt):
    return (x.low + x.high * 2 ** 128)
end
