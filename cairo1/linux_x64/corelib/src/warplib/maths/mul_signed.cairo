//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_cond_neg, uint256_signed_nn, uint256_neg, uint256_le
from warplib.maths.utils import felt_to_uint256
from warplib.maths.le import warp_le
from warplib.maths.mul import warp_mul8, warp_mul16, warp_mul24, warp_mul32, warp_mul40, warp_mul48, warp_mul56, warp_mul64, warp_mul72, warp_mul80, warp_mul88, warp_mul96, warp_mul104, warp_mul112, warp_mul120, warp_mul128, warp_mul136, warp_mul144, warp_mul152, warp_mul160, warp_mul168, warp_mul176, warp_mul184, warp_mul192, warp_mul200, warp_mul208, warp_mul216, warp_mul224, warp_mul232, warp_mul240, warp_mul248
from warplib.maths.negate import warp_negate8, warp_negate16, warp_negate24, warp_negate32, warp_negate40, warp_negate48, warp_negate56, warp_negate64, warp_negate72, warp_negate80, warp_negate88, warp_negate96, warp_negate104, warp_negate112, warp_negate120, warp_negate128, warp_negate136, warp_negate144, warp_negate152, warp_negate160, warp_negate168, warp_negate176, warp_negate184, warp_negate192, warp_negate200, warp_negate208, warp_negate216, warp_negate224, warp_negate232, warp_negate240, warp_negate248

func warp_mul_signed8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80);
        if (right_msb == 0){
            let (res) = warp_mul8(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate8(rhs);
            let (res_abs) = warp_mul8(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80);
            assert in_range = 1;
            let (res) = warp_negate8(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate8(lhs);
            let (res_abs) = warp_mul8(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80);
            assert in_range = 1;
            let (res) = warp_negate8(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate8(lhs);
            let (rhs_abs) = warp_negate8(rhs);
            let (res) = warp_mul8(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000);
        if (right_msb == 0){
            let (res) = warp_mul16(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate16(rhs);
            let (res_abs) = warp_mul16(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000);
            assert in_range = 1;
            let (res) = warp_negate16(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate16(lhs);
            let (res_abs) = warp_mul16(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000);
            assert in_range = 1;
            let (res) = warp_negate16(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate16(lhs);
            let (rhs_abs) = warp_negate16(rhs);
            let (res) = warp_mul16(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000);
        if (right_msb == 0){
            let (res) = warp_mul24(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate24(rhs);
            let (res_abs) = warp_mul24(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000);
            assert in_range = 1;
            let (res) = warp_negate24(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate24(lhs);
            let (res_abs) = warp_mul24(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000);
            assert in_range = 1;
            let (res) = warp_negate24(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate24(lhs);
            let (rhs_abs) = warp_negate24(rhs);
            let (res) = warp_mul24(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000);
        if (right_msb == 0){
            let (res) = warp_mul32(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate32(rhs);
            let (res_abs) = warp_mul32(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000);
            assert in_range = 1;
            let (res) = warp_negate32(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate32(lhs);
            let (res_abs) = warp_mul32(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000);
            assert in_range = 1;
            let (res) = warp_negate32(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate32(lhs);
            let (rhs_abs) = warp_negate32(rhs);
            let (res) = warp_mul32(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000);
        if (right_msb == 0){
            let (res) = warp_mul40(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate40(rhs);
            let (res_abs) = warp_mul40(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000);
            assert in_range = 1;
            let (res) = warp_negate40(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate40(lhs);
            let (res_abs) = warp_mul40(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000);
            assert in_range = 1;
            let (res) = warp_negate40(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate40(lhs);
            let (rhs_abs) = warp_negate40(rhs);
            let (res) = warp_mul40(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000);
        if (right_msb == 0){
            let (res) = warp_mul48(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate48(rhs);
            let (res_abs) = warp_mul48(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000);
            assert in_range = 1;
            let (res) = warp_negate48(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate48(lhs);
            let (res_abs) = warp_mul48(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000);
            assert in_range = 1;
            let (res) = warp_negate48(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate48(lhs);
            let (rhs_abs) = warp_negate48(rhs);
            let (res) = warp_mul48(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000);
        if (right_msb == 0){
            let (res) = warp_mul56(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate56(rhs);
            let (res_abs) = warp_mul56(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000);
            assert in_range = 1;
            let (res) = warp_negate56(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate56(lhs);
            let (res_abs) = warp_mul56(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000);
            assert in_range = 1;
            let (res) = warp_negate56(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate56(lhs);
            let (rhs_abs) = warp_negate56(rhs);
            let (res) = warp_mul56(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul64(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate64(rhs);
            let (res_abs) = warp_mul64(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000);
            assert in_range = 1;
            let (res) = warp_negate64(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate64(lhs);
            let (res_abs) = warp_mul64(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000);
            assert in_range = 1;
            let (res) = warp_negate64(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate64(lhs);
            let (rhs_abs) = warp_negate64(rhs);
            let (res) = warp_mul64(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul72(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate72(rhs);
            let (res_abs) = warp_mul72(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000);
            assert in_range = 1;
            let (res) = warp_negate72(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate72(lhs);
            let (res_abs) = warp_mul72(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000);
            assert in_range = 1;
            let (res) = warp_negate72(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate72(lhs);
            let (rhs_abs) = warp_negate72(rhs);
            let (res) = warp_mul72(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul80(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate80(rhs);
            let (res_abs) = warp_mul80(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate80(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate80(lhs);
            let (res_abs) = warp_mul80(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate80(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate80(lhs);
            let (rhs_abs) = warp_negate80(rhs);
            let (res) = warp_mul80(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul88(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate88(rhs);
            let (res_abs) = warp_mul88(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate88(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate88(lhs);
            let (res_abs) = warp_mul88(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate88(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate88(lhs);
            let (rhs_abs) = warp_negate88(rhs);
            let (res) = warp_mul88(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul96(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate96(rhs);
            let (res_abs) = warp_mul96(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate96(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate96(lhs);
            let (res_abs) = warp_mul96(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate96(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate96(lhs);
            let (rhs_abs) = warp_negate96(rhs);
            let (res) = warp_mul96(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul104(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate104(rhs);
            let (res_abs) = warp_mul104(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate104(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate104(lhs);
            let (res_abs) = warp_mul104(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate104(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate104(lhs);
            let (rhs_abs) = warp_negate104(rhs);
            let (res) = warp_mul104(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul112(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate112(rhs);
            let (res_abs) = warp_mul112(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate112(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate112(lhs);
            let (res_abs) = warp_mul112(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate112(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate112(lhs);
            let (rhs_abs) = warp_negate112(rhs);
            let (res) = warp_mul112(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul120(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate120(rhs);
            let (res_abs) = warp_mul120(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate120(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate120(lhs);
            let (res_abs) = warp_mul120(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate120(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate120(lhs);
            let (rhs_abs) = warp_negate120(rhs);
            let (res) = warp_mul120(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul128(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate128(rhs);
            let (res_abs) = warp_mul128(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate128(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate128(lhs);
            let (res_abs) = warp_mul128(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate128(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate128(lhs);
            let (rhs_abs) = warp_negate128(rhs);
            let (res) = warp_mul128(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul136(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate136(rhs);
            let (res_abs) = warp_mul136(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate136(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate136(lhs);
            let (res_abs) = warp_mul136(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate136(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate136(lhs);
            let (rhs_abs) = warp_negate136(rhs);
            let (res) = warp_mul136(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul144(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate144(rhs);
            let (res_abs) = warp_mul144(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate144(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate144(lhs);
            let (res_abs) = warp_mul144(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate144(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate144(lhs);
            let (rhs_abs) = warp_negate144(rhs);
            let (res) = warp_mul144(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul152(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate152(rhs);
            let (res_abs) = warp_mul152(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate152(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate152(lhs);
            let (res_abs) = warp_mul152(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate152(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate152(lhs);
            let (rhs_abs) = warp_negate152(rhs);
            let (res) = warp_mul152(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul160(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate160(rhs);
            let (res_abs) = warp_mul160(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate160(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate160(lhs);
            let (res_abs) = warp_mul160(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate160(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate160(lhs);
            let (rhs_abs) = warp_negate160(rhs);
            let (res) = warp_mul160(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul168(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate168(rhs);
            let (res_abs) = warp_mul168(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate168(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate168(lhs);
            let (res_abs) = warp_mul168(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate168(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate168(lhs);
            let (rhs_abs) = warp_negate168(rhs);
            let (res) = warp_mul168(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul176(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate176(rhs);
            let (res_abs) = warp_mul176(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate176(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate176(lhs);
            let (res_abs) = warp_mul176(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate176(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate176(lhs);
            let (rhs_abs) = warp_negate176(rhs);
            let (res) = warp_mul176(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul184(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate184(rhs);
            let (res_abs) = warp_mul184(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate184(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate184(lhs);
            let (res_abs) = warp_mul184(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate184(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate184(lhs);
            let (rhs_abs) = warp_negate184(rhs);
            let (res) = warp_mul184(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul192(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate192(rhs);
            let (res_abs) = warp_mul192(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate192(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate192(lhs);
            let (res_abs) = warp_mul192(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate192(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate192(lhs);
            let (rhs_abs) = warp_negate192(rhs);
            let (res) = warp_mul192(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul200(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate200(rhs);
            let (res_abs) = warp_mul200(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate200(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate200(lhs);
            let (res_abs) = warp_mul200(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate200(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate200(lhs);
            let (rhs_abs) = warp_negate200(rhs);
            let (res) = warp_mul200(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul208(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate208(rhs);
            let (res_abs) = warp_mul208(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate208(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate208(lhs);
            let (res_abs) = warp_mul208(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate208(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate208(lhs);
            let (rhs_abs) = warp_negate208(rhs);
            let (res) = warp_mul208(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul216(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate216(rhs);
            let (res_abs) = warp_mul216(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate216(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate216(lhs);
            let (res_abs) = warp_mul216(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate216(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate216(lhs);
            let (rhs_abs) = warp_negate216(rhs);
            let (res) = warp_mul216(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul224(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate224(rhs);
            let (res_abs) = warp_mul224(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate224(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate224(lhs);
            let (res_abs) = warp_mul224(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate224(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate224(lhs);
            let (rhs_abs) = warp_negate224(rhs);
            let (res) = warp_mul224(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul232(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate232(rhs);
            let (res_abs) = warp_mul232(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate232(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate232(lhs);
            let (res_abs) = warp_mul232(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x8000000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate232(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate232(lhs);
            let (rhs_abs) = warp_negate232(rhs);
            let (res) = warp_mul232(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x8000000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul240(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate240(rhs);
            let (res_abs) = warp_mul240(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate240(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate240(lhs);
            let (res_abs) = warp_mul240(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x800000000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate240(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate240(lhs);
            let (rhs_abs) = warp_negate240(rhs);
            let (res) = warp_mul240(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x800000000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (left_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    if (left_msb == 0){
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (res) = warp_mul248(lhs, rhs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }else{
            let (rhs_abs) = warp_negate248(rhs);
            let (res_abs) = warp_mul248(lhs, rhs_abs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate248(res_abs);
            return (res,);
        }
    }else{
        let (right_msb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
        if (right_msb == 0){
            let (lhs_abs) = warp_negate248(lhs);
            let (res_abs) = warp_mul248(lhs_abs, rhs);
            let (in_range) = warp_le(res_abs, 0x80000000000000000000000000000000000000000000000000000000000000);
            assert in_range = 1;
            let (res) = warp_negate248(res_abs);
            return (res,);
        }else{
            let (lhs_abs) = warp_negate248(lhs);
            let (rhs_abs) = warp_negate248(rhs);
            let (res) = warp_mul248(lhs_abs, rhs_abs);
            let (res_msb) = bitwise_and(res, 0x80000000000000000000000000000000000000000000000000000000000000);
            assert res_msb = 0;
            return (res,);
        }
    }
}
func warp_mul_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Uint256, rhs : Uint256) -> (result : Uint256){
    alloc_locals;
    // 1 => lhs >= 0, 0 => lhs < 0
    let (lhs_nn) = uint256_signed_nn(lhs);
    // 1 => rhs >= 0, 0 => rhs < 0
    let (local rhs_nn) = uint256_signed_nn(rhs);
    // negates if arg is 1, which is if lhs_nn is 0, which is if lhs < 0
    let (lhs_abs) = uint256_cond_neg(lhs, 1 - lhs_nn);
    // negates if arg is 1
    let (rhs_abs) = uint256_cond_neg(rhs, 1 - rhs_nn);
    let (res_abs, overflow) = uint256_mul(lhs_abs, rhs_abs);
    assert overflow.low = 0;
    assert overflow.high = 0;
    let res_should_be_neg = lhs_nn + rhs_nn;
    if (res_should_be_neg == 1){
        let (in_range) = uint256_le(res_abs, Uint256(0,0x80000000000000000000000000000000));
        assert in_range = 1;
        let (negated) = uint256_neg(res_abs);
        return (negated,);
    }else{
        let (msb) = bitwise_and(res_abs.high, 0x80000000000000000000000000000000);
        assert msb = 0;
        return (res_abs,);
    }
}
