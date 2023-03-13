//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_signed_div_rem, uint256_eq
from warplib.maths.utils import felt_to_uint256
from warplib.maths.int_conversions import warp_int8_to_int256, warp_int16_to_int256, warp_int24_to_int256, warp_int32_to_int256, warp_int40_to_int256, warp_int48_to_int256, warp_int56_to_int256, warp_int64_to_int256, warp_int72_to_int256, warp_int80_to_int256, warp_int88_to_int256, warp_int96_to_int256, warp_int104_to_int256, warp_int112_to_int256, warp_int120_to_int256, warp_int128_to_int256, warp_int136_to_int256, warp_int144_to_int256, warp_int152_to_int256, warp_int160_to_int256, warp_int168_to_int256, warp_int176_to_int256, warp_int184_to_int256, warp_int192_to_int256, warp_int200_to_int256, warp_int208_to_int256, warp_int216_to_int256, warp_int224_to_int256, warp_int232_to_int256, warp_int240_to_int256, warp_int248_to_int256, warp_int256_to_int8, warp_int256_to_int16, warp_int256_to_int24, warp_int256_to_int32, warp_int256_to_int40, warp_int256_to_int48, warp_int256_to_int56, warp_int256_to_int64, warp_int256_to_int72, warp_int256_to_int80, warp_int256_to_int88, warp_int256_to_int96, warp_int256_to_int104, warp_int256_to_int112, warp_int256_to_int120, warp_int256_to_int128, warp_int256_to_int136, warp_int256_to_int144, warp_int256_to_int152, warp_int256_to_int160, warp_int256_to_int168, warp_int256_to_int176, warp_int256_to_int184, warp_int256_to_int192, warp_int256_to_int200, warp_int256_to_int208, warp_int256_to_int216, warp_int256_to_int224, warp_int256_to_int232, warp_int256_to_int240, warp_int256_to_int248
from warplib.maths.mul_signed_unsafe import warp_mul_signed_unsafe8,warp_mul_signed_unsafe16,warp_mul_signed_unsafe24,warp_mul_signed_unsafe32,warp_mul_signed_unsafe40,warp_mul_signed_unsafe48,warp_mul_signed_unsafe56,warp_mul_signed_unsafe64,warp_mul_signed_unsafe72,warp_mul_signed_unsafe80,warp_mul_signed_unsafe88,warp_mul_signed_unsafe96,warp_mul_signed_unsafe104,warp_mul_signed_unsafe112,warp_mul_signed_unsafe120,warp_mul_signed_unsafe128,warp_mul_signed_unsafe136,warp_mul_signed_unsafe144,warp_mul_signed_unsafe152,warp_mul_signed_unsafe160,warp_mul_signed_unsafe168,warp_mul_signed_unsafe176,warp_mul_signed_unsafe184,warp_mul_signed_unsafe192,warp_mul_signed_unsafe200,warp_mul_signed_unsafe208,warp_mul_signed_unsafe216,warp_mul_signed_unsafe224,warp_mul_signed_unsafe232,warp_mul_signed_unsafe240,warp_mul_signed_unsafe248,warp_mul_signed_unsafe256

func warp_div_signed_unsafe8{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xff){
        let (res : felt) = warp_mul_signed_unsafe8(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int8_to_int256(lhs);
    let (rhs_256) = warp_int8_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int8(res256);
    return (truncated,);
}
func warp_div_signed_unsafe16{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffff){
        let (res : felt) = warp_mul_signed_unsafe16(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int16_to_int256(lhs);
    let (rhs_256) = warp_int16_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int16(res256);
    return (truncated,);
}
func warp_div_signed_unsafe24{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffff){
        let (res : felt) = warp_mul_signed_unsafe24(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int24_to_int256(lhs);
    let (rhs_256) = warp_int24_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int24(res256);
    return (truncated,);
}
func warp_div_signed_unsafe32{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffff){
        let (res : felt) = warp_mul_signed_unsafe32(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int32_to_int256(lhs);
    let (rhs_256) = warp_int32_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int32(res256);
    return (truncated,);
}
func warp_div_signed_unsafe40{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffff){
        let (res : felt) = warp_mul_signed_unsafe40(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int40_to_int256(lhs);
    let (rhs_256) = warp_int40_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int40(res256);
    return (truncated,);
}
func warp_div_signed_unsafe48{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe48(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int48_to_int256(lhs);
    let (rhs_256) = warp_int48_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int48(res256);
    return (truncated,);
}
func warp_div_signed_unsafe56{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe56(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int56_to_int256(lhs);
    let (rhs_256) = warp_int56_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int56(res256);
    return (truncated,);
}
func warp_div_signed_unsafe64{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe64(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int64_to_int256(lhs);
    let (rhs_256) = warp_int64_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int64(res256);
    return (truncated,);
}
func warp_div_signed_unsafe72{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe72(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int72_to_int256(lhs);
    let (rhs_256) = warp_int72_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int72(res256);
    return (truncated,);
}
func warp_div_signed_unsafe80{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe80(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int80_to_int256(lhs);
    let (rhs_256) = warp_int80_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int80(res256);
    return (truncated,);
}
func warp_div_signed_unsafe88{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe88(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int88_to_int256(lhs);
    let (rhs_256) = warp_int88_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int88(res256);
    return (truncated,);
}
func warp_div_signed_unsafe96{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe96(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int96_to_int256(lhs);
    let (rhs_256) = warp_int96_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int96(res256);
    return (truncated,);
}
func warp_div_signed_unsafe104{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe104(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int104_to_int256(lhs);
    let (rhs_256) = warp_int104_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int104(res256);
    return (truncated,);
}
func warp_div_signed_unsafe112{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe112(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int112_to_int256(lhs);
    let (rhs_256) = warp_int112_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int112(res256);
    return (truncated,);
}
func warp_div_signed_unsafe120{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe120(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int120_to_int256(lhs);
    let (rhs_256) = warp_int120_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int120(res256);
    return (truncated,);
}
func warp_div_signed_unsafe128{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe128(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int128_to_int256(lhs);
    let (rhs_256) = warp_int128_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int128(res256);
    return (truncated,);
}
func warp_div_signed_unsafe136{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe136(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int136_to_int256(lhs);
    let (rhs_256) = warp_int136_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int136(res256);
    return (truncated,);
}
func warp_div_signed_unsafe144{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe144(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int144_to_int256(lhs);
    let (rhs_256) = warp_int144_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int144(res256);
    return (truncated,);
}
func warp_div_signed_unsafe152{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe152(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int152_to_int256(lhs);
    let (rhs_256) = warp_int152_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int152(res256);
    return (truncated,);
}
func warp_div_signed_unsafe160{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe160(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int160_to_int256(lhs);
    let (rhs_256) = warp_int160_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int160(res256);
    return (truncated,);
}
func warp_div_signed_unsafe168{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe168(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int168_to_int256(lhs);
    let (rhs_256) = warp_int168_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int168(res256);
    return (truncated,);
}
func warp_div_signed_unsafe176{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe176(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int176_to_int256(lhs);
    let (rhs_256) = warp_int176_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int176(res256);
    return (truncated,);
}
func warp_div_signed_unsafe184{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe184(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int184_to_int256(lhs);
    let (rhs_256) = warp_int184_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int184(res256);
    return (truncated,);
}
func warp_div_signed_unsafe192{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe192(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int192_to_int256(lhs);
    let (rhs_256) = warp_int192_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int192(res256);
    return (truncated,);
}
func warp_div_signed_unsafe200{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe200(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int200_to_int256(lhs);
    let (rhs_256) = warp_int200_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int200(res256);
    return (truncated,);
}
func warp_div_signed_unsafe208{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe208(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int208_to_int256(lhs);
    let (rhs_256) = warp_int208_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int208(res256);
    return (truncated,);
}
func warp_div_signed_unsafe216{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe216(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int216_to_int256(lhs);
    let (rhs_256) = warp_int216_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int216(res256);
    return (truncated,);
}
func warp_div_signed_unsafe224{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe224(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int224_to_int256(lhs);
    let (rhs_256) = warp_int224_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int224(res256);
    return (truncated,);
}
func warp_div_signed_unsafe232{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe232(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int232_to_int256(lhs);
    let (rhs_256) = warp_int232_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int232(res256);
    return (truncated,);
}
func warp_div_signed_unsafe240{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe240(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int240_to_int256(lhs);
    let (rhs_256) = warp_int240_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int240(res256);
    return (truncated,);
}
func warp_div_signed_unsafe248{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    if (rhs == 0){
        with_attr error_message("Division by zero error"){
            assert 1 = 0;
        }
    }
    if (rhs == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff){
        let (res : felt) = warp_mul_signed_unsafe248(lhs, rhs);
        return (res,);
    }
    let (local lhs_256) = warp_int248_to_int256(lhs);
    let (rhs_256) = warp_int248_to_int256(rhs);
    let (res256, _) = uint256_signed_div_rem(lhs_256, rhs_256);
    let (truncated) = warp_int256_to_int248(res256);
    return (truncated,);
}
func warp_div_signed_unsafe256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){
    if (rhs.high == 0 and rhs.low == 0){
        with_attr error_message("Division by zero error"){
           assert 1 = 0;
        }
    }
    let (is_minus_one) = uint256_eq(rhs, Uint256(0xffffffffffffffffffffffffffffffff, 0xffffffffffffffffffffffffffffffff));
    if (is_minus_one == 1){
        let (res : Uint256) = warp_mul_signed_unsafe256(lhs, rhs);
        return (res,);
    }
    let (res : Uint256, _) = uint256_signed_div_rem(lhs, rhs);
    return (res,);
}
