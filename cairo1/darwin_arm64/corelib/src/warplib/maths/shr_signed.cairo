//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le, is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_and
from warplib.maths.pow2 import pow2
from warplib.maths.shr import warp_shr8, warp_shr16, warp_shr24, warp_shr32, warp_shr40, warp_shr48, warp_shr56, warp_shr64, warp_shr72, warp_shr80, warp_shr88, warp_shr96, warp_shr104, warp_shr112, warp_shr120, warp_shr128, warp_shr136, warp_shr144, warp_shr152, warp_shr160, warp_shr168, warp_shr176, warp_shr184, warp_shr192, warp_shr200, warp_shr208, warp_shr216, warp_shr224, warp_shr232, warp_shr240, warp_shr248, warp_shr256

func warp_shr_signed8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr8(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(8, rhs);
        if (large_shift == 1){
            return (0xff,);
        }else{
            let (shifted) = warp_shr8(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(8 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed8_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr8(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr8(lhs, 8);
        return (res,);
    }
}
func warp_shr_signed16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr16(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(16, rhs);
        if (large_shift == 1){
            return (0xffff,);
        }else{
            let (shifted) = warp_shr16(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(16 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed16_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr16(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr16(lhs, 16);
        return (res,);
    }
}
func warp_shr_signed24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr24(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(24, rhs);
        if (large_shift == 1){
            return (0xffffff,);
        }else{
            let (shifted) = warp_shr24(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(24 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed24_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr24(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr24(lhs, 24);
        return (res,);
    }
}
func warp_shr_signed32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr32(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(32, rhs);
        if (large_shift == 1){
            return (0xffffffff,);
        }else{
            let (shifted) = warp_shr32(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(32 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed32_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr32(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr32(lhs, 32);
        return (res,);
    }
}
func warp_shr_signed40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr40(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(40, rhs);
        if (large_shift == 1){
            return (0xffffffffff,);
        }else{
            let (shifted) = warp_shr40(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(40 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed40_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr40(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr40(lhs, 40);
        return (res,);
    }
}
func warp_shr_signed48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr48(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(48, rhs);
        if (large_shift == 1){
            return (0xffffffffffff,);
        }else{
            let (shifted) = warp_shr48(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(48 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed48_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr48(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr48(lhs, 48);
        return (res,);
    }
}
func warp_shr_signed56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr56(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(56, rhs);
        if (large_shift == 1){
            return (0xffffffffffffff,);
        }else{
            let (shifted) = warp_shr56(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(56 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed56_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr56(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr56(lhs, 56);
        return (res,);
    }
}
func warp_shr_signed64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr64(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(64, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffff,);
        }else{
            let (shifted) = warp_shr64(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(64 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed64_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr64(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr64(lhs, 64);
        return (res,);
    }
}
func warp_shr_signed72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr72(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(72, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr72(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(72 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed72_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr72(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr72(lhs, 72);
        return (res,);
    }
}
func warp_shr_signed80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr80(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(80, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr80(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(80 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed80_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr80(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr80(lhs, 80);
        return (res,);
    }
}
func warp_shr_signed88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr88(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(88, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr88(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(88 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed88_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr88(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr88(lhs, 88);
        return (res,);
    }
}
func warp_shr_signed96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr96(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(96, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr96(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(96 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed96_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr96(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr96(lhs, 96);
        return (res,);
    }
}
func warp_shr_signed104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr104(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(104, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr104(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(104 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed104_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr104(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr104(lhs, 104);
        return (res,);
    }
}
func warp_shr_signed112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr112(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(112, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr112(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(112 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed112_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr112(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr112(lhs, 112);
        return (res,);
    }
}
func warp_shr_signed120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr120(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(120, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr120(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(120 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed120_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr120(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr120(lhs, 120);
        return (res,);
    }
}
func warp_shr_signed128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr128(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(128, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr128(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(128 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed128_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr128(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr128(lhs, 128);
        return (res,);
    }
}
func warp_shr_signed136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr136(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(136, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr136(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(136 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed136_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr136(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr136(lhs, 136);
        return (res,);
    }
}
func warp_shr_signed144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr144(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(144, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr144(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(144 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed144_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr144(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr144(lhs, 144);
        return (res,);
    }
}
func warp_shr_signed152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr152(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(152, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr152(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(152 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed152_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr152(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr152(lhs, 152);
        return (res,);
    }
}
func warp_shr_signed160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr160(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(160, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr160(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(160 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed160_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr160(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr160(lhs, 160);
        return (res,);
    }
}
func warp_shr_signed168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr168(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(168, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr168(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(168 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed168_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr168(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr168(lhs, 168);
        return (res,);
    }
}
func warp_shr_signed176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr176(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(176, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr176(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(176 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed176_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr176(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr176(lhs, 176);
        return (res,);
    }
}
func warp_shr_signed184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr184(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(184, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr184(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(184 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed184_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr184(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr184(lhs, 184);
        return (res,);
    }
}
func warp_shr_signed192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr192(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(192, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr192(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(192 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed192_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr192(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr192(lhs, 192);
        return (res,);
    }
}
func warp_shr_signed200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr200(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(200, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr200(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(200 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed200_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr200(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr200(lhs, 200);
        return (res,);
    }
}
func warp_shr_signed208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr208(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(208, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr208(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(208 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed208_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr208(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr208(lhs, 208);
        return (res,);
    }
}
func warp_shr_signed216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr216(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(216, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr216(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(216 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed216_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr216(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr216(lhs, 216);
        return (res,);
    }
}
func warp_shr_signed224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr224(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(224, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr224(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(224 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed224_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr224(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr224(lhs, 224);
        return (res,);
    }
}
func warp_shr_signed232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr232(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(232, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr232(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(232 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed232_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr232(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr232(lhs, 232);
        return (res,);
    }
}
func warp_shr_signed240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr240(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(240, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr240(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(240 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed240_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr240(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr240(lhs, 240);
        return (res,);
    }
}
func warp_shr_signed248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        let (res) = warp_shr248(lhs, rhs);
        return (res,);
    }else{
        let large_shift = is_le_felt(248, rhs);
        if (large_shift == 1){
            return (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,);
        }else{
            let (shifted) = warp_shr248(lhs, rhs);
            let (sign_extend_bound) = pow2(rhs);
            let sign_extend_value = sign_extend_bound - 1;
            let (sign_extend_multiplier) = pow2(248 - rhs);
            return (shifted + sign_extend_value * sign_extend_multiplier,);
        }
    }
}
func warp_shr_signed248_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : Uint256) -> (res : felt){
    if (rhs.high == 0){
        let (res) = warp_shr248(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr248(lhs, 248);
        return (res,);
    }
}
func warp_shr_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : felt) -> (res : Uint256){
    alloc_locals;
    let (local lhs_msb) = bitwise_and(lhs.high, 0x80000000000000000000000000000000);
    let (logical_shift) = warp_shr256(lhs, rhs);
    if (lhs_msb == 0){
        return (logical_shift,);
    }else{
        let large_shift = is_le(256, rhs);
        if (large_shift == 1){
            return (Uint256(0xffffffffffffffffffffffffffffffff, 0xffffffffffffffffffffffffffffffff),);
        }else{
            let crosses_boundary = is_le(128, rhs);
            if (crosses_boundary == 1){
                let (bound) = pow2(rhs-128);
                let ones = bound - 1;
                let (shift) = pow2(256-rhs);
                return (Uint256(logical_shift.low+ones*shift, 0xffffffffffffffffffffffffffffffff),);
            }else{
                let (bound) = pow2(rhs);
                let ones = bound - 1;
                let (shift) = pow2(128-rhs);
                return (Uint256(logical_shift.low, logical_shift.high+ones*shift),);
            }
        }
    }
}
func warp_shr_signed256_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){
    if (rhs.high == 0){
        let (res) = warp_shr_signed256(lhs, rhs.low);
        return (res,);
    }else{
        let (res) = warp_shr_signed256(lhs, 256);
        return (res,);
    }
}
