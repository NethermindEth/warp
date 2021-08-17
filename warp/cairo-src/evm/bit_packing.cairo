from starkware.cairo.common.math import assert_lt, unsigned_div_rem
from starkware.cairo.common.pow import pow
from starkware.cairo.common.uint256 import uint256_shl, Uint256

func extract_unaligned_uint128{range_check_ptr}(shift, low, high) -> (value):
    # Given two aligned uint128's, extract an unaligned uint128,
    # shifted by 'shift' bytes from the 'high' high end.
    let x = Uint256(low=low, high=high)
    let (y) = uint256_shl(x, Uint256(low=8 * shift, high=0))
    return (y.high)
end

func put_unaligned_uint128{range_check_ptr}(shift, low, high, value) -> (low, high):
    # Given two aligned uint128's, and a third 'value',
    # return two uint128's with 'value' replacing bytes of 'low' and
    # 'high' shifted by 'shift' bytes from the 'high' high end.
    alloc_locals
    let (local d1) = exp_byte(shift)
    let (d2) = exp_byte(16 - shift)
    let (high_h, _) = unsigned_div_rem(high, d2)
    let (_, low_l) = unsigned_div_rem(low, d2)
    let (value_h, value_l) = unsigned_div_rem(value, d1)
    return (low=low_l + value_l * d2, high=value_h + high_h * d2)
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

func exp_byte{range_check_ptr}(d) -> (res):
    return pow(256, d)
end

func extract_byte{range_check_ptr}(x, pos) -> (low, byte, high):
    # Extract byte at the position 'pos' in 'x', as well as bytes
    # lower than 'pos' higher than 'pos'.
    alloc_locals
    let (local low, rest) = split_on_byte(x, pos)
    let (byte, high) = split_on_byte(rest, 1)
    return (low, byte, high)
end

func put_byte{range_check_ptr}(pos, low, byte, high) -> (x):
    let (d) = exp_byte(pos)
    return ((high * 256 + byte) * d + low)
end
