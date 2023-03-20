//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_cond_neg, uint256_signed_nn
from warplib.maths.mul_unsafe import warp_mul_unsafe8, warp_mul_unsafe16, warp_mul_unsafe24, warp_mul_unsafe32, warp_mul_unsafe40, warp_mul_unsafe48, warp_mul_unsafe56, warp_mul_unsafe64, warp_mul_unsafe72, warp_mul_unsafe80, warp_mul_unsafe88, warp_mul_unsafe96, warp_mul_unsafe104, warp_mul_unsafe112, warp_mul_unsafe120, warp_mul_unsafe128, warp_mul_unsafe136, warp_mul_unsafe144, warp_mul_unsafe152, warp_mul_unsafe160, warp_mul_unsafe168, warp_mul_unsafe176, warp_mul_unsafe184, warp_mul_unsafe192, warp_mul_unsafe200, warp_mul_unsafe208, warp_mul_unsafe216, warp_mul_unsafe224, warp_mul_unsafe232, warp_mul_unsafe240, warp_mul_unsafe248
from warplib.maths.negate import warp_negate8, warp_negate16, warp_negate24, warp_negate32, warp_negate40, warp_negate48, warp_negate56, warp_negate64, warp_negate72, warp_negate80, warp_negate88, warp_negate96, warp_negate104, warp_negate112, warp_negate120, warp_negate128, warp_negate136, warp_negate144, warp_negate152, warp_negate160, warp_negate168, warp_negate176, warp_negate184, warp_negate192, warp_negate200, warp_negate208, warp_negate216, warp_negate224, warp_negate232, warp_negate240, warp_negate248
from warplib.maths.utils import felt_to_uint256

func warp_mul_signed_unsafe8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80);
    let (local right_msb) = bitwise_and(rhs, 0x80);
    let (res) = warp_mul_unsafe8(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100 - left_msb - right_msb);
    if (not_neg == 0x80){
        let (res) = warp_negate8(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000);
    let (local right_msb) = bitwise_and(rhs, 0x8000);
    let (res) = warp_mul_unsafe16(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000 - left_msb - right_msb);
    if (not_neg == 0x8000){
        let (res) = warp_negate16(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000);
    let (local right_msb) = bitwise_and(rhs, 0x800000);
    let (res) = warp_mul_unsafe24(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000 - left_msb - right_msb);
    if (not_neg == 0x800000){
        let (res) = warp_negate24(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000);
    let (res) = warp_mul_unsafe32(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000 - left_msb - right_msb);
    if (not_neg == 0x80000000){
        let (res) = warp_negate32(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000);
    let (res) = warp_mul_unsafe40(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000){
        let (res) = warp_negate40(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000);
    let (res) = warp_mul_unsafe48(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000){
        let (res) = warp_negate48(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000);
    let (res) = warp_mul_unsafe56(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000){
        let (res) = warp_negate56(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000);
    let (res) = warp_mul_unsafe64(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000){
        let (res) = warp_negate64(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000);
    let (res) = warp_mul_unsafe72(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000){
        let (res) = warp_negate72(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000);
    let (res) = warp_mul_unsafe80(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000){
        let (res) = warp_negate80(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000);
    let (res) = warp_mul_unsafe88(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000){
        let (res) = warp_negate88(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000);
    let (res) = warp_mul_unsafe96(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000){
        let (res) = warp_negate96(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000);
    let (res) = warp_mul_unsafe104(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000){
        let (res) = warp_negate104(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000);
    let (res) = warp_mul_unsafe112(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000000000){
        let (res) = warp_negate112(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000);
    let (res) = warp_mul_unsafe120(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000000000){
        let (res) = warp_negate120(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000);
    let (res) = warp_mul_unsafe128(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000000000){
        let (res) = warp_negate128(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
    let (res) = warp_mul_unsafe136(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000000000000000){
        let (res) = warp_negate136(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
    let (res) = warp_mul_unsafe144(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000000000000000){
        let (res) = warp_negate144(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe152(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000000000000000){
        let (res) = warp_negate152(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe160(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000000000000000000000){
        let (res) = warp_negate160(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe168(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000000000000000000000){
        let (res) = warp_negate168(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe176(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000000000000000000000){
        let (res) = warp_negate176(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe184(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000000000000000000000000000){
        let (res) = warp_negate184(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe192(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000000000000000000000000000){
        let (res) = warp_negate192(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe200(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000000000000000000000000000){
        let (res) = warp_negate200(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe208(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000000000000000000000000000000000){
        let (res) = warp_negate208(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe216(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000000000000000000000000000000000){
        let (res) = warp_negate216(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe224(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000000000000000000000000000000000){
        let (res) = warp_negate224(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe232(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x10000000000000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x8000000000000000000000000000000000000000000000000000000000){
        let (res) = warp_negate232(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe240(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x1000000000000000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x800000000000000000000000000000000000000000000000000000000000){
        let (res) = warp_negate240(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (local right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (res) = warp_mul_unsafe248(lhs, rhs);
    let not_neg = (left_msb + right_msb) * (0x100000000000000000000000000000000000000000000000000000000000000 - left_msb - right_msb);
    if (not_neg == 0x80000000000000000000000000000000000000000000000000000000000000){
        let (res) = warp_negate248(res);
        return (res,);
    }else{
        return (res,);
    }
}
func warp_mul_signed_unsafe256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Uint256, rhs : Uint256) -> (result : Uint256){
    alloc_locals;
    let (lhs_nn) = uint256_signed_nn(lhs);
    let (local rhs_nn) = uint256_signed_nn(rhs);
    let (lhs_abs) = uint256_cond_neg(lhs, lhs_nn);
    let (rhs_abs) = uint256_cond_neg(rhs, rhs_nn);
    let (res_abs, _) = uint256_mul(lhs_abs, rhs_abs);
    let (res) = uint256_cond_neg(res_abs, (lhs_nn + rhs_nn) * (2 - lhs_nn - rhs_nn));
    return (res,);
}
