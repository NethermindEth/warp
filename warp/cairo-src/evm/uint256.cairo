from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import (
    Uint256, felt_and, uint256_add, uint256_cond_neg, uint256_eq, uint256_lt, uint256_mul,
    uint256_pow2, uint256_shl, uint256_shr, uint256_signed_lt, uint256_sub,
    uint256_unsigned_div_rem, uint256_signed_div_rem)
from starkware.cairo.common.math_cmp import is_le


func u256_add{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    alloc_locals
    let (local result : Uint256, _) = uint256_add(x, y)
    return (result=result)
end

func u256_mul{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    alloc_locals
    let (local result : Uint256, _) = uint256_mul(x, y)
    return (result=result)
end

func u256_sdiv{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    alloc_locals
    let (local result : Uint256, _) = uint256_signed_div_rem(x, y)
    return (result=result)
end

func u256_div{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    alloc_locals
    let (local result : Uint256, _) = uint256_unsigned_div_rem(x, y)
    return (result=result)
end

# THE ORDER OF ARGUMENTS IS REVERSED, LIKE IN YUL
func u256_shr{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    alloc_locals
    let (local result : Uint256) = uint256_shr(y, x)
    return (result=result)
end

# THE ORDER OF ARGUMENTS IS REVERSED, LIKE IN YUL
func u256_shl{range_check_ptr}(x : Uint256, y : Uint256) -> (result : Uint256):
    alloc_locals
    let (local result : Uint256) = uint256_shl(y, x)
    return (result=result)
end

func is_zero{range_check_ptr}(x : Uint256) -> (result : Uint256):
    if x.high != 0:
        tempvar range_check_ptr = range_check_ptr
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
    alloc_locals
    let (local res) = uint256_eq(op1, op2)
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
    let (res) = uint256_signed_lt(op1, op2)
    return (result=Uint256(1 - res, 0))
end

func uint256_mod{range_check_ptr}(a : Uint256, m : Uint256) -> (res : Uint256):
    assert 0 = 1  # not implemented yet =(
    jmp rel 0
end

func uint256_addmod{range_check_ptr}(a : Uint256, b : Uint256, m : Uint256) -> (res : Uint256):
    assert 0 = 1  # not implemented yet =(
    jmp rel 0
end

func smod{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (res : Uint256):
    let (_, rem : Uint256) = uint256_signed_div_rem(op1, op2)
    return (res=rem)
end

func extract_lowest_byte{range_check_ptr}(x : Uint256) -> (byte : felt, rest : Uint256):
    let (quot, rem) = uint256_unsigned_div_rem(x, Uint256(256, 0))
    return (byte=rem.low, rest=quot)
end

func uint256_sar{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    let (c) = uint256_pow2(b)
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
    let (low) = felt_and(res.low, 255, 8)
    return (res=cast((low, 0), Uint256))
end

func uint256_exp{range_check_ptr}(a : Uint256, b : Uint256) -> (res : Uint256):
    assert 0 = 1  # not implemented yet =(
    jmp rel 0
end

func uint256_mulmod{range_check_ptr}(a : Uint256, b : Uint256, m : Uint256) -> (res : Uint256):
    assert 0 = 1  # not implemented yet =(
    jmp rel 0
end
