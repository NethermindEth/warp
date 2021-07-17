from starkware.cairo.common.math import assert_nn_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le

# Represents an integer in the range [0, 2^256).
struct Uint256:
    # The low 128 bits of the value.
    member low : felt
    # The high 128 bits of the value.
    member high : felt
end

const SHIFT = %[2 ** 128%]
const HALF_SHIFT = %[2 ** 64%]

# Verifies that the given integer is valid.
func uint256_check{range_check_ptr}(a : Uint256):
    [range_check_ptr] = a.low
    [range_check_ptr + 1] = a.high
    let range_check_ptr = range_check_ptr + 2
    return ()
end

# Arithmetics.

# Adds two integers. Returns the result as a 256-bit integer and the (1-bit) carry.
func uint256_add{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256, carry : felt):
    alloc_locals
    local res : Uint256
    local carry_low : felt
    local carry_high : felt
    %{
        sum_low = ids.a.low + ids.b.low
        ids.carry_low = 1 if sum_low >= ids.SHIFT else 0
        sum_high = ids.a.high + ids.b.high + ids.carry_low
        ids.carry_high = 1 if sum_high >= ids.SHIFT else 0
    %}

    assert carry_low * carry_low = carry_low
    assert carry_high * carry_high = carry_high

    assert res.low = a.low + b.low - carry_low * SHIFT
    assert res.high = a.high + b.high + carry_low - carry_high * SHIFT
    uint256_check(res)

    return (res, carry_high)
end

# Splits a field element in the range [0, 2^192) to its low 64-bit and high 128-bit parts.
func split_64{range_check_ptr}(a : felt) -> (low : felt, high : felt):
    alloc_locals
    local low : felt
    local high : felt

    %{
        ids.low = ids.a & ((1<<64) - 1)
        ids.high = ids.a >> 64
    %}
    assert_nn_le(low, HALF_SHIFT)
    [range_check_ptr] = high
    let range_check_ptr = range_check_ptr + 1
    return (low, high)
end

# Multiplies two integers. Returns the result as two 256-bit integers (low and high parts).
func uint256_mul{range_check_ptr}(a : Uint256, b : Uint256) -> (low : Uint256, high : Uint256):
    alloc_locals
    let (a0, a1) = split_64(a.low)
    let (a2, a3) = split_64(a.high)
    let (b0, b1) = split_64(b.low)
    let (b2, b3) = split_64(b.high)

    let (res0, carry) = split_64(a0 * b0)
    let (res1, carry) = split_64(a1 * b0 + a0 * b1 + carry)
    let (res2, carry) = split_64(a2 * b0 + a1 * b1 + a0 * b2 + carry)
    let (res3, carry) = split_64(a3 * b0 + a2 * b1 + a1 * b2 + a0 * b3 + carry)
    let (res4, carry) = split_64(a3 * b1 + a2 * b2 + a1 * b3 + carry)
    let (res5, carry) = split_64(a3 * b2 + a2 * b3 + carry)
    let (res6, carry) = split_64(a3 * b3 + carry)

    return (
        low=cast((low=res0 + HALF_SHIFT * res1, high=res2 + HALF_SHIFT * res3), Uint256),
        high=cast((low=res4 + HALF_SHIFT * res5, high=res6 + HALF_SHIFT * carry), Uint256))
end

func uint256_unsigned_div_rem{range_check_ptr}(a : Uint256, div : Uint256) -> (
        quot : Uint256, rem : Uint256):
    alloc_locals
    local quot : Uint256
    local rem : Uint256

    if div.low + div.high == 0:
        return (quot=cast((0, 0), Uint256), rem=cast((0, 0), Uint256))
    end

    %{
        a = (ids.a.high<<128)+ids.a.low
        div = (ids.div.high<<128)+ids.div.low
        quot = a // div
        rem = a % div

        ids.quot.low = quot & ((1<<128)-1)
        ids.quot.high = quot >> 128
        ids.rem.low = rem & ((1<<128)-1)
        ids.rem.high = rem >> 128
    %}
    let (res_mul, carry) = uint256_mul(quot, div)
    assert carry = cast((0, 0), Uint256)

    let (check_val, _) = uint256_add(res_mul, rem)
    assert check_val = a

    let (is_valid) = uint256_lt(rem, div)
    assert is_valid = 1
    return (quot=quot, rem=rem)
end

func uint256_cond_neg{range_check_ptr}(a : Uint256, should_neg) -> (res : Uint256):
    if should_neg != 0:
        let (neg) = uint256_neg(a)
        return (res=neg)
    else:
        return (res=a)
    end
end

func uint256_not{range_check_ptr}(a : Uint256) -> (res : Uint256):
    return (cast((low=%[2**128-1%] - a.low, high=%[2**128-1%] - a.high), Uint256))
end

func uint256_neg{range_check_ptr}(a : Uint256) -> (res : Uint256):
    let (not_num) = uint256_not(a)
    let (res, _) = uint256_add(not_num, cast((low=1, high=0), Uint256))
    return (res)
end

func uint256_signed_div_rem{range_check_ptr}(a : Uint256, div : Uint256) -> (
        quot : Uint256, rem : Uint256):
    alloc_locals

    # Edge case when div=-1.
    if div.low == SHIFT - 1:
        if div.high == SHIFT - 1:
            let (quot) = uint256_neg(a)
            return (quot, cast((0, 0), Uint256))
        end
    end

    let (local is_a_low) = is_le(a.high, %[2**127 - 1%])
    local range_check_ptr = range_check_ptr
    let (local a) = uint256_cond_neg(a, should_neg=1 - is_a_low)

    let (local is_div_low) = is_le(div.high, %[2**127 - 1%])
    local range_check_ptr = range_check_ptr
    let (div) = uint256_cond_neg(div, should_neg=1 - is_div_low)

    let (local quot, local rem) = uint256_unsigned_div_rem(a, div)
    local range_check_ptr = range_check_ptr
    if is_a_low == is_div_low:
        return (quot=quot, rem=rem)
    end

    let (local quot_neg) = uint256_neg(quot)
    let (rem_neg) = uint256_neg(rem)
    return (quot=quot_neg, rem=rem_neg)
end

func uint256_sub{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    let (b_neg) = uint256_neg(b)
    let (res, _) = uint256_add(a, b_neg)
    return (res)
end

func uint256_exp128{range_check_ptr}(a : Uint256, b : felt, n) -> (res : Uint256, new_a : Uint256):
    if b == 0:
        return (res=cast((low=1, high=0), Uint256), new_a=a)
    end

    alloc_locals
    local bit
    %{ ids.bit = ids.b&1 %}
    bit * bit = bit
    assert_not_zero(n)

    let (a2, _) = uint256_mul(a, a)
    let (res, new_a) = uint256_exp128(a2, (b - bit) / 2, n - 1)
    if bit != 0:
        let (res, _) = uint256_mul(res, a)
        return (res=res, new_a=new_a)
    else:
        return (res=res, new_a=new_a)
    end
end

func uint256_exp{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    alloc_locals
    let (local res0, new_a) = uint256_exp128(a, b.low, 128)
    let (res1, _) = uint256_exp128(new_a, b.high, 128)
    let (res, _) = uint256_mul(res0, res1)
    return (res=res)
end

func uint256_mod{range_check_ptr}(a : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    local should_reduce
    %{
        if (ids.m.high == 0 and ids.m.low == 0) or \
                (ids.a.high, ids.a.low) >= (ids.m.high, ids.m.low):
            ids.should_reduce = 1
        else:
            ids.should_reduce = 0
    %}
    if should_reduce == 0:
        let (is_lt) = uint256_lt(a, m)
        assert is_lt = 1
        return (a)
    end
    let (_, a) = uint256_signed_div_rem(a, m)
    return (a)
end

func uint256_addmod{range_check_ptr}(a : Uint256, b : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    let (local a) = uint256_mod(a, m)
    let (local b) = uint256_mod(b, m)
    let (local res, carry) = uint256_add(a, b)
    if carry != 0:
        return uint256_sub(res, m)
    end
    let (is_lt) = uint256_lt(res, m)
    if is_lt != 0:
        return (res)
    else:
        return uint256_sub(res, m)
    end
end

func uint256_mulmod128{range_check_ptr}(a : Uint256, b : felt, m : Uint256, n) -> (
        res : Uint256, new_a : Uint256):
    if b == 0:
        return (res=cast((low=1, high=0), Uint256), new_a=a)
    end

    alloc_locals
    local bit
    %{ ids.bit = ids.b&1 %}
    bit * bit = bit
    assert_not_zero(n)

    let (a2) = uint256_addmod(a, a, m)
    let (res, local new_a) = uint256_mulmod128(a2, (b - bit) / 2, m, n - 1)
    if bit != 0:
        let (res) = uint256_addmod(res, a, m)
        return (res=res, new_a=new_a)
    else:
        return (res=res, new_a=new_a)
    end
end

func uint256_mulmod{range_check_ptr}(a : Uint256, b : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    let (local res0, new_a) = uint256_mulmod128(a, b.low, m, 128)
    let (res1, _) = uint256_mulmod128(new_a, b.high, m, 128)
    let (res) = uint256_addmod(res0, res1, m)
    return (res=res)
end

# Logical.
func uint256_lt{range_check_ptr}(a : Uint256, b : Uint256) -> (res):
    if a.high == b.high:
        return is_le(a.low + 1, b.low)
    end
    return is_le(a.high + 1, b.high)
end

func uint256_signed_lt{range_check_ptr}(a : Uint256, b : Uint256) -> (res):
    let (a, _) = uint256_add(a, cast((low=0, high=%[2**127%]), Uint256))
    let (b, _) = uint256_add(b, cast((low=0, high=%[2**127%]), Uint256))
    return uint256_lt(a, b)
end

func uint256_eq{range_check_ptr}(a : Uint256, b : Uint256) -> (res):
    if a.high != b.high:
        return (0)
    end
    if a.low != b.low:
        return (0)
    end
    return (1)
end

# Bitwise.
func uint128_xor{range_check_ptr}(a, b, n) -> (res : felt):
    alloc_locals
    local a0
    local b0

    if n == 0:
        assert a = 0
        assert b = 0
        return (0)
    end

    %{
        ids.a0 = ids.a&1
        ids.b0 = ids.b&1
    %}
    assert a0 * a0 = a0
    assert b0 * b0 = b0

    local res_bit = a0 + b0 - 2 * a0 * b0

    let (res) = uint128_xor((a - a0) / 2, (b - b0) / 2, n - 1)
    return (res=res * 2 + res_bit)
end

func uint128_and{range_check_ptr}(a, b, n) -> (res : felt):
    alloc_locals
    local a0
    local b0

    if n == 0:
        assert a = 0
        assert b = 0
        return (res=0)
    end

    %{
        ids.a0 = ids.a&1
        ids.b0 = ids.b&1
    %}
    assert a0 * a0 = a0
    assert b0 * b0 = b0

    local res_bit = a0 * b0

    let (res) = uint128_and((a - a0) / 2, (b - b0) / 2, n - 1)
    return (res=res * 2 + res_bit)
end

func uint256_xor{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    alloc_locals
    let (local low) = uint128_xor(a.low, b.low, 128)
    let (high) = uint128_xor(a.high, b.high, 128)
    return (cast((low, high), Uint256))
end

func uint256_and{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    alloc_locals
    let (local low) = uint128_and(a.low, b.low, 128)
    let (high) = uint128_and(a.high, b.high, 128)
    return (cast((low, high), Uint256))
end

func uint256_or{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    let (a) = uint256_not(a)
    let (b) = uint256_not(b)
    let (res) = uint256_and(a, b)
    return uint256_not(res)
end

func uint256_shl{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    let (c) = uint256_exp(cast((2, 0), Uint256), b)
    let (res, _) = uint256_mul(a, c)
    return (res)
end

func uint256_shr{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    let (c) = uint256_exp(cast((2, 0), Uint256), b)
    let (res, _) = uint256_unsigned_div_rem(a, c)
    return (res)
end

func uint256_sar{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    let (c) = uint256_exp(cast((2, 0), Uint256), b)
    let (res, _) = uint256_signed_div_rem(a, c)
    return (res)
end

func uint256_signextend{range_check_ptr}(a : Uint256, i : Uint256) -> (res : Uint256):
    alloc_locals
    let (i, _) = uint256_mul(i, cast((8, 0), Uint256))
    let (local i) = uint256_sub(cast((248, 0), Uint256), i)
    let (a) = uint256_shl(a, i)
    let (a) = uint256_sar(a, i)
    return (a)
end

func uint256_byte{range_check_ptr}(a : Uint256, i : Uint256) -> (res : Uint256):
    let (i, _) = uint256_mul(i, cast((8, 0), Uint256))
    let (i) = uint256_sub(cast((248, 0), Uint256), i)
    let (res) = uint256_shr(a, i)
    let (low) = uint128_and(res.low, 255, 8)
    return (res=cast((low, 0), Uint256))
end
