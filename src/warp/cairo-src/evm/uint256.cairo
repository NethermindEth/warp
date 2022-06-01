from starkware.cairo.common.bitwise import bitwise_and, bitwise_not, bitwise_or
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_not_zero, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.pow import pow
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_cond_neg, uint256_eq, uint256_lt, uint256_mul, uint256_pow2,
    uint256_shl, uint256_signed_div_rem, uint256_signed_lt, uint256_sub, uint256_unsigned_div_rem)

from evm.pow2 import pow2

const UINT128_BOUND = 2 ** 128

func shr_helper{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(i, a : Uint256) -> (
        result : Uint256):
    alloc_locals
    let (le_127) = is_le(i, 127)
    if le_127 == 1:
        # (h', l') := (h, l) >> i
        # p := 2^i
        # l' = ((h & (p-1)) << (128 - i)) + ((l&~(p-1)) >> i)
        #    = ((h & (p-1)) << 128 >> i) + ((l&~(p-1)) >> i)
        #    = (h & (p-1)) * 2^128 / p + (l&~(p-1)) / p
        #    = (h & (p-1) * 2^128 + l&~(p-1)) / p
        # h' = h >> i = (h - h&(p-1)) / p
        let (p) = pow2(i)
        let (low_mask) = bitwise_not(p - 1)
        let (low_part) = bitwise_and(a.low, low_mask)
        let (high_part) = bitwise_and(a.high, p - 1)
        return (
            Uint256(low=(low_part + UINT128_BOUND * high_part) / p, high=(a.high - high_part) / p))
    end
    let (le_255) = is_le(i, 255)
    if le_255 == 1:
        let (p) = pow2(i - 128)
        let (mask) = bitwise_not(p - 1)
        let (res) = bitwise_and(a.high, mask)
        return (Uint256(res / p, 0))
    end
    return (Uint256(0, 0))
end

func u256_add{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    let (result : Uint256, _) = uint256_add(x, y)
    return (result=result)
end

func u256_mul{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    let (result : Uint256, _) = uint256_mul(x, y)
    return (result=result)
end

func u256_sdiv{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    let (result : Uint256, _) = uint256_signed_div_rem(x, y)
    return (result=result)
end

func u256_div{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    let (result : Uint256, _) = uint256_unsigned_div_rem(x, y)
    return (result=result)
end

# THE ORDER OF ARGUMENTS IS REVERSED, LIKE IN YUL
func u256_shr{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(i : Uint256, a : Uint256) -> (
        result : Uint256):
    if i.high != 0:
        return (Uint256(0, 0))
    end
    return shr_helper(i.low, a)
end

# THE ORDER OF ARGUMENTS IS REVERSED, LIKE IN YUL
func u256_shl{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    let (result : Uint256) = uint256_shl(y, x)
    return (result=result)
end

func is_zero{range_check_ptr}(x : Uint256) -> (result : Uint256):
    if x.high != 0:
        return (result=Uint256(0, 0))
    else:
        if x.low != 0:
            return (result=Uint256(0, 0))
        else:
            return (result=Uint256(1, 0))
        end
    end
end

func is_eq{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_eq(op1, op2)
    return (result=Uint256(res, 0))
end

func is_gt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_lt(op2, op1)
    return (result=Uint256(res, 0))
end

# strict less than. Returns 1 if op1 < op2, and 0 otherwise
func is_lt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_lt(op1, op2)
    return (result=Uint256(res, 0))
end

func slt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_signed_lt(op1, op2)
    return (result=Uint256(res, 0))
end

func sgt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (eq) = uint256_eq(op1, op2)
    if eq == 1:
        return (Uint256(0, 0))
    end
    let (res) = uint256_signed_lt(op1, op2)
    return (result=Uint256(1 - res, 0))
end

func uint256_mod{range_check_ptr}(a : Uint256, m : Uint256) -> (res : Uint256):
    let (_, rem) = uint256_unsigned_div_rem(a, m)
    return (rem)
end

func uint256_addmod{range_check_ptr}(a : Uint256, b : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    let (_, ar) = uint256_unsigned_div_rem(a, m)
    let (_, br) = uint256_unsigned_div_rem(b, m)
    return addmod_helper(ar, br, m)
end

func smod{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (res : Uint256):
    let (_, rem : Uint256) = uint256_signed_div_rem(op1, op2)
    return (res=rem)
end

func extract_lowest_byte{range_check_ptr}(x : Uint256) -> (byte : felt, rest : Uint256):
    let (quot, rem) = uint256_unsigned_div_rem(x, Uint256(256, 0))
    return (byte=rem.low, rest=quot)
end

func uint256_sar{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(i : Uint256, a : Uint256) -> (
        res : Uint256):
    alloc_locals
    let (a_neg) = is_le(2 ** 127, a.high)
    if a_neg == 0:
        return u256_shr(i, a)
    end
    if i.high != 0:
        return (Uint256(2 ** 128 - 1, 2 ** 128 - 1))
    end
    let (shred) = shr_helper(i.low, a)
    let (le_127) = is_le(i.low, 127)
    if le_127 == 1:
        let mask = UINT128_BOUND - 1
        let (mask_low) = pow2(128 - i.low)
        let mask = mask - (mask_low - 1)
        let (res_high) = bitwise_or(shred.high, mask)
        return (Uint256(shred.low, res_high))
    end
    let (le_255) = is_le(i.low, 255)
    if le_255 == 1:
        let mask = UINT128_BOUND - 1
        let (mask_low) = pow2(256 - i.low)
        let mask = mask - (mask_low - 1)
        # turn bits higher than 128 off
        let (res_low) = bitwise_or(shred.low, mask)
        return (Uint256(res_low, 2 ** 128 - 1))
    end
    return (Uint256(2 ** 128 - 1, 2 ** 128 - 1))
end

func uint256_signextend{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        i : Uint256, a : Uint256) -> (res : Uint256):
    alloc_locals
    let (i, _) = uint256_mul(i, Uint256(8, 0))
    let (i) = uint256_sub(Uint256(248, 0), i)
    let (a) = uint256_shl(a, i)
    let (a) = uint256_sar(i, a)
    return (a)
end

func uint256_byte{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(i : Uint256, a : Uint256) -> (
        res : Uint256):
    let (i, _) = uint256_mul(i, Uint256(8, 0))
    let (i) = uint256_sub(Uint256(248, 0), i)
    let (res) = u256_shr(i, a)
    let (low) = bitwise_and(res.low, 255)
    return (res=Uint256(low, 0))
end

func uint256_exp{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(a : Uint256, b : Uint256) -> (
        res : Uint256):
    alloc_locals
    if b.low + b.high == 0:
        return (Uint256(1, 0))
    end
    let (b_half) = u256_shr(Uint256(1, 0), b)
    let (r1) = uint256_exp(a, b_half)
    let (r2, _) = uint256_mul(r1, r1)
    let (odd) = bitwise_and(b.low, 1)
    if odd == 1:
        let (r3, _) = uint256_mul(r2, a)
        return (r3)
    else:
        return (r2)
    end
end

func uint256_mulmod{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        a : Uint256, b : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    let (_, ar) = uint256_unsigned_div_rem(a, m)
    let (_, br) = uint256_unsigned_div_rem(b, m)
    return mulmod_helper(ar, br, m)
end

func mulmod_helper{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        ar : Uint256, br : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    if br.low + br.high == 0:
        return (Uint256(1, 0))
    end
    let (br_half) = u256_shr(Uint256(1, 0), br)
    let (r1) = mulmod_helper(ar, br_half, m)
    let (r2) = addmod_helper(r1, r1, m)
    let (odd) = bitwise_and(br.low, 1)
    if odd == 1:
        let (r3) = addmod_helper(r2, ar, m)
        return (r3)
    else:
        return (r2)
    end
end

func addmod_helper{range_check_ptr}(ar : Uint256, br : Uint256, m : Uint256) -> (res : Uint256):
    alloc_locals
    let (ar_c) = uint256_sub(m, ar)
    let (fits) = uint256_lt(br, ar_c)
    if fits == 1:
        return u256_add(ar, br)
    else:
        return uint256_sub(br, ar_c)
    end
end
