//AUTO-GENERATED
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_signed_lt
from warplib.maths.utils import felt_to_uint256
from warplib.maths.le_signed import warp_le_signed8, warp_le_signed16, warp_le_signed24, warp_le_signed32, warp_le_signed40, warp_le_signed48, warp_le_signed56, warp_le_signed64, warp_le_signed72, warp_le_signed80, warp_le_signed88, warp_le_signed96, warp_le_signed104, warp_le_signed112, warp_le_signed120, warp_le_signed128, warp_le_signed136, warp_le_signed144, warp_le_signed152, warp_le_signed160, warp_le_signed168, warp_le_signed176, warp_le_signed184, warp_le_signed192, warp_le_signed200, warp_le_signed208, warp_le_signed216, warp_le_signed224, warp_le_signed232, warp_le_signed240, warp_le_signed248

func warp_lt_signed8{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed8(lhs, rhs);
    return (res,);
}
func warp_lt_signed16{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed16(lhs, rhs);
    return (res,);
}
func warp_lt_signed24{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed24(lhs, rhs);
    return (res,);
}
func warp_lt_signed32{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed32(lhs, rhs);
    return (res,);
}
func warp_lt_signed40{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed40(lhs, rhs);
    return (res,);
}
func warp_lt_signed48{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed48(lhs, rhs);
    return (res,);
}
func warp_lt_signed56{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed56(lhs, rhs);
    return (res,);
}
func warp_lt_signed64{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed64(lhs, rhs);
    return (res,);
}
func warp_lt_signed72{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed72(lhs, rhs);
    return (res,);
}
func warp_lt_signed80{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed80(lhs, rhs);
    return (res,);
}
func warp_lt_signed88{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed88(lhs, rhs);
    return (res,);
}
func warp_lt_signed96{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed96(lhs, rhs);
    return (res,);
}
func warp_lt_signed104{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed104(lhs, rhs);
    return (res,);
}
func warp_lt_signed112{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed112(lhs, rhs);
    return (res,);
}
func warp_lt_signed120{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed120(lhs, rhs);
    return (res,);
}
func warp_lt_signed128{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed128(lhs, rhs);
    return (res,);
}
func warp_lt_signed136{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed136(lhs, rhs);
    return (res,);
}
func warp_lt_signed144{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed144(lhs, rhs);
    return (res,);
}
func warp_lt_signed152{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed152(lhs, rhs);
    return (res,);
}
func warp_lt_signed160{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed160(lhs, rhs);
    return (res,);
}
func warp_lt_signed168{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed168(lhs, rhs);
    return (res,);
}
func warp_lt_signed176{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed176(lhs, rhs);
    return (res,);
}
func warp_lt_signed184{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed184(lhs, rhs);
    return (res,);
}
func warp_lt_signed192{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed192(lhs, rhs);
    return (res,);
}
func warp_lt_signed200{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed200(lhs, rhs);
    return (res,);
}
func warp_lt_signed208{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed208(lhs, rhs);
    return (res,);
}
func warp_lt_signed216{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed216(lhs, rhs);
    return (res,);
}
func warp_lt_signed224{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed224(lhs, rhs);
    return (res,);
}
func warp_lt_signed232{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed232(lhs, rhs);
    return (res,);
}
func warp_lt_signed240{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed240(lhs, rhs);
    return (res,);
}
func warp_lt_signed248{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    if (lhs == rhs){
        return (0,);
    }
    let (res) = warp_le_signed248(lhs, rhs);
    return (res,);
}
func warp_lt_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt){
    let (res) = uint256_signed_lt(lhs, rhs);
    return (res,);
}
