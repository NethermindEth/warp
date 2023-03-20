//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_sub
from warplib.maths.mul import warp_mul8, warp_mul16, warp_mul24, warp_mul32, warp_mul40, warp_mul48, warp_mul56, warp_mul64, warp_mul72, warp_mul80, warp_mul88, warp_mul96, warp_mul104, warp_mul112, warp_mul120, warp_mul128, warp_mul136, warp_mul144, warp_mul152, warp_mul160, warp_mul168, warp_mul176, warp_mul184, warp_mul192, warp_mul200, warp_mul208, warp_mul216, warp_mul224, warp_mul232, warp_mul240, warp_mul248, warp_mul256

func _repeated_multiplication8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication8(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul8(op, x);
        return (res,);
    }
}
func warp_exp8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication8(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_8(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul8(op, x);
    return (res,);
}
func warp_exp_wide8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_8(lhs, rhs);
    return (res,);
}
func _repeated_multiplication16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication16(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul16(op, x);
        return (res,);
    }
}
func warp_exp16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication16(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_16(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul16(op, x);
    return (res,);
}
func warp_exp_wide16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_16(lhs, rhs);
    return (res,);
}
func _repeated_multiplication24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication24(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul24(op, x);
        return (res,);
    }
}
func warp_exp24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication24(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_24(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul24(op, x);
    return (res,);
}
func warp_exp_wide24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_24(lhs, rhs);
    return (res,);
}
func _repeated_multiplication32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication32(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul32(op, x);
        return (res,);
    }
}
func warp_exp32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication32(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_32(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul32(op, x);
    return (res,);
}
func warp_exp_wide32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_32(lhs, rhs);
    return (res,);
}
func _repeated_multiplication40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication40(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul40(op, x);
        return (res,);
    }
}
func warp_exp40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication40(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_40(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul40(op, x);
    return (res,);
}
func warp_exp_wide40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_40(lhs, rhs);
    return (res,);
}
func _repeated_multiplication48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication48(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul48(op, x);
        return (res,);
    }
}
func warp_exp48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication48(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_48(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul48(op, x);
    return (res,);
}
func warp_exp_wide48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_48(lhs, rhs);
    return (res,);
}
func _repeated_multiplication56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication56(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul56(op, x);
        return (res,);
    }
}
func warp_exp56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication56(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_56(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul56(op, x);
    return (res,);
}
func warp_exp_wide56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_56(lhs, rhs);
    return (res,);
}
func _repeated_multiplication64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication64(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul64(op, x);
        return (res,);
    }
}
func warp_exp64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication64(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_64(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul64(op, x);
    return (res,);
}
func warp_exp_wide64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_64(lhs, rhs);
    return (res,);
}
func _repeated_multiplication72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication72(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul72(op, x);
        return (res,);
    }
}
func warp_exp72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication72(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_72(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul72(op, x);
    return (res,);
}
func warp_exp_wide72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_72(lhs, rhs);
    return (res,);
}
func _repeated_multiplication80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication80(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul80(op, x);
        return (res,);
    }
}
func warp_exp80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication80(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_80(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul80(op, x);
    return (res,);
}
func warp_exp_wide80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_80(lhs, rhs);
    return (res,);
}
func _repeated_multiplication88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication88(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul88(op, x);
        return (res,);
    }
}
func warp_exp88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication88(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_88(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul88(op, x);
    return (res,);
}
func warp_exp_wide88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_88(lhs, rhs);
    return (res,);
}
func _repeated_multiplication96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication96(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul96(op, x);
        return (res,);
    }
}
func warp_exp96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication96(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_96(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul96(op, x);
    return (res,);
}
func warp_exp_wide96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_96(lhs, rhs);
    return (res,);
}
func _repeated_multiplication104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication104(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul104(op, x);
        return (res,);
    }
}
func warp_exp104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication104(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_104(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul104(op, x);
    return (res,);
}
func warp_exp_wide104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_104(lhs, rhs);
    return (res,);
}
func _repeated_multiplication112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication112(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul112(op, x);
        return (res,);
    }
}
func warp_exp112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication112(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_112(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul112(op, x);
    return (res,);
}
func warp_exp_wide112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_112(lhs, rhs);
    return (res,);
}
func _repeated_multiplication120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication120(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul120(op, x);
        return (res,);
    }
}
func warp_exp120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication120(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_120(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul120(op, x);
    return (res,);
}
func warp_exp_wide120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_120(lhs, rhs);
    return (res,);
}
func _repeated_multiplication128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication128(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul128(op, x);
        return (res,);
    }
}
func warp_exp128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication128(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_128(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul128(op, x);
    return (res,);
}
func warp_exp_wide128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_128(lhs, rhs);
    return (res,);
}
func _repeated_multiplication136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication136(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul136(op, x);
        return (res,);
    }
}
func warp_exp136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication136(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_136(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul136(op, x);
    return (res,);
}
func warp_exp_wide136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_136(lhs, rhs);
    return (res,);
}
func _repeated_multiplication144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication144(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul144(op, x);
        return (res,);
    }
}
func warp_exp144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication144(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_144(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul144(op, x);
    return (res,);
}
func warp_exp_wide144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_144(lhs, rhs);
    return (res,);
}
func _repeated_multiplication152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication152(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul152(op, x);
        return (res,);
    }
}
func warp_exp152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication152(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_152(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul152(op, x);
    return (res,);
}
func warp_exp_wide152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_152(lhs, rhs);
    return (res,);
}
func _repeated_multiplication160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication160(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul160(op, x);
        return (res,);
    }
}
func warp_exp160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication160(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_160(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul160(op, x);
    return (res,);
}
func warp_exp_wide160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_160(lhs, rhs);
    return (res,);
}
func _repeated_multiplication168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication168(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul168(op, x);
        return (res,);
    }
}
func warp_exp168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication168(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_168(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul168(op, x);
    return (res,);
}
func warp_exp_wide168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_168(lhs, rhs);
    return (res,);
}
func _repeated_multiplication176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication176(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul176(op, x);
        return (res,);
    }
}
func warp_exp176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication176(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_176(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul176(op, x);
    return (res,);
}
func warp_exp_wide176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_176(lhs, rhs);
    return (res,);
}
func _repeated_multiplication184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication184(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul184(op, x);
        return (res,);
    }
}
func warp_exp184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication184(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_184(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul184(op, x);
    return (res,);
}
func warp_exp_wide184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_184(lhs, rhs);
    return (res,);
}
func _repeated_multiplication192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication192(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul192(op, x);
        return (res,);
    }
}
func warp_exp192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication192(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_192(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul192(op, x);
    return (res,);
}
func warp_exp_wide192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_192(lhs, rhs);
    return (res,);
}
func _repeated_multiplication200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication200(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul200(op, x);
        return (res,);
    }
}
func warp_exp200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication200(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_200(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul200(op, x);
    return (res,);
}
func warp_exp_wide200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_200(lhs, rhs);
    return (res,);
}
func _repeated_multiplication208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication208(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul208(op, x);
        return (res,);
    }
}
func warp_exp208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication208(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_208(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul208(op, x);
    return (res,);
}
func warp_exp_wide208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_208(lhs, rhs);
    return (res,);
}
func _repeated_multiplication216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication216(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul216(op, x);
        return (res,);
    }
}
func warp_exp216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication216(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_216(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul216(op, x);
    return (res,);
}
func warp_exp_wide216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_216(lhs, rhs);
    return (res,);
}
func _repeated_multiplication224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication224(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul224(op, x);
        return (res,);
    }
}
func warp_exp224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication224(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_224(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul224(op, x);
    return (res,);
}
func warp_exp_wide224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_224(lhs, rhs);
    return (res,);
}
func _repeated_multiplication232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication232(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul232(op, x);
        return (res,);
    }
}
func warp_exp232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication232(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_232(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul232(op, x);
    return (res,);
}
func warp_exp_wide232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_232(lhs, rhs);
    return (res,);
}
func _repeated_multiplication240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication240(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul240(op, x);
        return (res,);
    }
}
func warp_exp240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication240(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_240(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul240(op, x);
    return (res,);
}
func warp_exp_wide240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_240(lhs, rhs);
    return (res,);
}
func _repeated_multiplication248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){
    alloc_locals;
    if (count == 0){
        return (1,);
    }else{
        let (x) = _repeated_multiplication248(op, count - 1);
        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
        let (res) = warp_mul248(op, x);
        return (res,);
    }
}
func warp_exp248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    if (rhs == 0){
        return (1,);
    }
    if (lhs * (lhs-1) * (rhs-1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication248(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){
    alloc_locals;
    if (count.low == 0 and count.high == 0){
        return (1,);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_248(op, decr);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    let (res) = warp_mul248(op, x);
    return (res,);
}
func warp_exp_wide248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.low == 0){
        if (rhs.high == 0){
            return (1,);
        }
    }
    if (lhs * (lhs-1) == 0){
        return (lhs,);
    }
    if (rhs.low == 1 and rhs.high == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_248(lhs, rhs);
    return (res,);
}
func _repeated_multiplication256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : Uint256, count : felt) -> (res : Uint256){
    if (count == 0){
        return (Uint256(1, 0),);
    }
    let (x) = _repeated_multiplication256(op, count - 1);
    let (res) = warp_mul256(op, x);
    return (res,);
}
func warp_exp256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : felt) -> (res : Uint256){
    if (rhs == 0){
        return (Uint256(1, 0),);
    }
    if (lhs.high == 0){
        if (lhs.low * (lhs.low - 1) == 0){
            return (lhs,);
        }
    }
    let (res) = _repeated_multiplication256(lhs, rhs);
    return (res,);
}
func _repeated_multiplication_256_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : Uint256, count : Uint256) -> (res : Uint256){
    if (count.low == 0 and count.high == 0){
        return (Uint256(1, 0),);
    }
    let (decr) = uint256_sub(count, Uint256(1, 0));
    let (x) = _repeated_multiplication_256_256(op, decr);
    let (res) = warp_mul256(op, x);
    return (res,);
}
func warp_exp_wide256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){
    if (rhs.high == 0 and rhs.low == 0){
        return (Uint256(1, 0),);
    }
    if (lhs.high == 0 and lhs.low * (lhs.low - 1) == 0){
        return (lhs,);
    }
    let (res) = _repeated_multiplication_256_256(lhs, rhs);
    return (res,);
}
