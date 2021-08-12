from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import (
    Uint256,
    felt_and,
    uint256_add,
    uint256_cond_neg,
    uint256_eq,
    uint256_lt,
    uint256_mul,
    uint256_pow2,
    uint256_shl,
    uint256_shr,
    uint256_signed_div_rem,
    uint256_signed_lt,
    uint256_sub,
    uint256_unsigned_div_rem,
    )
from starkware.cairo.common.math_cmp import is_le

func is_zero{range_check_ptr}(x : Uint256 ) -> (result : Uint256):
    if x.high != 0:
        tempvar range_check_ptr = range_check_ptr
        return (result=Uint256(0,0))
    else:
        if x.low != 0:
            tempvar range_check_ptr = range_check_ptr
            return (result=Uint256(0,0))
        else:
            tempvar range_check_ptr = range_check_ptr
            return (result=Uint256(1,0))
        end
    end
end

func is_eq{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    alloc_locals
    let (local res) = uint256_eq(op1, op2)
    return (result=Uint256(res, 0))
end

func is_gt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    alloc_locals
    let (local eq) = uint256_eq(op1, op2)
    if eq == 1:
        tempvar range_check_ptr = range_check_ptr
        return (result=Uint256(0,0))
    else:
        let (local res) = uint256_lt(op1, op2)
        if res == 0:
            tempvar range_check_ptr = range_check_ptr
            return (result=Uint256(1,0))
        else:
            tempvar range_check_ptr = range_check_ptr
            return (result=Uint256(0,0))
        end
    end
end

# strict less than. Returns 1 if op1 < op2, and 0 otherwise
func is_lt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    alloc_locals
    let (local eq) = uint256_eq{range_check_ptr=range_check_ptr}(op1 ,op2)
    if eq == 1:
        return (result=Uint256(0,0))
    else:
        let (local res) = uint256_lt{range_check_ptr=range_check_ptr}(op1, op2)
        return (result=Uint256(res, 0))
    end
end

func slt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    alloc_locals
    let (local res) = uint256_signed_lt(op1, op2)
    return (result=Uint256(res, 0))
end

func sgt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    alloc_locals
    let (local eq) = uint256_eq(op1 ,op2)
    if eq != 0:
        tempvar range_check_ptr = range_check_ptr
        return (result=Uint256(0,0))
    else:
        tempvar range_check_ptr = range_check_ptr
        let (local res) = uint256_signed_lt(op1, op2)
        if res == 0:
            tempvar range_check_ptr = range_check_ptr
            return (result=Uint256(1, 0))
        else:
            tempvar range_check_ptr = range_check_ptr
            return (result=Uint256(0, 0))
        end
    end
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

func smod{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (res : Uint256):
    alloc_locals
    local twos_upper = 170141183460469231731687303715884105727
    let (local op1_is_low) = is_le(op1.high, twos_upper)
    local range_check_ptr = range_check_ptr
    let (local op1_mod_op2) = uint256_mod(op1, op2)

    local range_check_ptr = range_check_ptr
    let (local res) = uint256_cond_neg(op1_mod_op2, should_neg=1 - op1_is_low)

    return (res)
end

func get_max{range_check_ptr}(op1, op2) -> (result):
    is_le(op1, op2)
    if [ap - 1] == 1:
        return (op2)
    else:
        return (op1)
    end
end

func extract_lowest_byte{range_check_ptr}(x: Uint256)
    -> (byte: felt, rest: Uint256):
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
