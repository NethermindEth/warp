from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_cond_neg,
    uint256_eq,
    uint256_lt,
    uint256_mod,
    uint256_signed_lt,
    uint256_unsigned_div_rem,
    uint256_signed_div_rem,
    )
from starkware.cairo.common.math_cmp import is_le

func is_zero{range_check_ptr}(x : Uint256 ) -> (result : Uint256):
    if x.high != 0:
        tempvar range_check_ptr = range_check_ptr
        return (result=Uint256(0,0))
    else:
        if x.low != 0:
            return (result=Uint256(0,0))
        else:
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
    let (res) = uint256_lt(op2, op1)
    return Uint256(1-res, 0)
end

# strict less than. Returns 1 if op1 < op2, and 0 otherwise
func is_lt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_lt(op2, op1)
    return (result=Uint256(res, 0))
end

func slt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_signed_lt(op1, op2)
    return (result=Uint256(res, 0))
end

func sgt{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (result : Uint256):
    let (res) = uint256_signed_lt(op1, op2)
    return (result=Uint256(1-res, 0))
end

func smod{range_check_ptr}(op1 : Uint256, op2 : Uint256) -> (res : Uint256):
    let (local div : Uint256, rem : Uint256) = uint256_signed_div_rem(op1, op2)
    return (res=rem)
end

func get_max{range_check_ptr}(op1, op2) -> (result):
    let (res) = is_le(op1, op2)
    if res == 1:
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
