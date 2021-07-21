from starkware.cairo.common.math import assert_lt, unsigned_div_rem

from evm.utils import round_down_to_multiple

func read_uint128{range_check_ptr}(offset, lower_v, higher_v) -> (value):
    alloc_locals
    let value = 0

    let (local lower) = round_down_to_multiple(offset, 16)
    local lower_overlap = lower + 16 - offset
    let (value) = replace_higher_bytes(value, lower_v, lower_overlap)

    if lower_overlap == 16:
        return (value)
    end

    let higher = lower + 16
    let higher_overlap = 16 - lower_overlap
    let (value) = replace_lower_bytes(value, higher_v, higher_overlap)

    return (value)
end

func write_uint128{range_check_ptr}(offset, lower_v, higher_v, value)
    -> (lower_v, higher_v):
    alloc_locals
    let (local lower) = round_down_to_multiple(offset, 16)
    local lower_overlap = lower + 16 - offset
    let (local lower_v) = replace_lower_bytes(lower_v, value, lower_overlap)

    if lower_overlap == 16:
        return (lower_v, higher_v)
    end

    let higher = lower + 16
    let higher_overlap = 16 - lower_overlap
    let (higher_v) = replace_higher_bytes(higher_v, value, higher_overlap)
    return (lower_v, higher_v)
end


func replace_lower_bytes{range_check_ptr}(a, b, n) -> (res):
    # Replace 'n' lower _bytes_ of 'a' with 'n' higher _bytes_ of
    # 'b'. Assume, 'a' and 'b' are 128-bit (16-byte) wide.
    alloc_locals
    let (_, local high) = split_on_byte(a, n)
    let (_, local low) = split_on_byte(b, 16 - n)
    local range_check_ptr = range_check_ptr
    let (d) = exp_byte(n)
    return (high * d + low)
end

func replace_higher_bytes{range_check_ptr}(a, b, n) -> (res):
    # Replace 'n' higher _bytes_ of 'a' with 'n' lower _bytes_ of
    # 'b'. Assume, 'a' and 'b' are 128-bit (16-byte) wide.
    alloc_locals
    let (local low, _) = split_on_byte(a, 16 - n)
    let (local high, _) = split_on_byte(b, n)
    local range_check_ptr = range_check_ptr
    let (co_d) = exp_byte(16 - n)
    return (high * co_d + low)
end

func split_on_byte{range_check_ptr}(value, byte_pos) -> (low, high):
    # For a 128-bit integer 'value' return its 'byte_pos' lower bytes
    # and '16 - byte_pos' higher bytes.
    alloc_locals

    # 'unsigned_div_rem' can't handle 256**16
    if byte_pos == 16:
        return (value, 0)
    end
    assert_lt(byte_pos, 16)
    local range_check_ptr = range_check_ptr
    let (d) = exp_byte(byte_pos)
    let (q, r) = unsigned_div_rem(value, d)
    return (low=r, high=q)
end

func exp_byte(d) -> (res):
    # Compute '256^d'. Very slow, but we expect 'd' to be ≤ 16. The
    # fast version would require hints and they aren't allowed on
    # starknet. We can actually make a jump table... hmmm
    if d == 0:
        return (1)
    else:
        exp_byte(d - 1)
        return ([ap - 1] * 256)
    end
end
