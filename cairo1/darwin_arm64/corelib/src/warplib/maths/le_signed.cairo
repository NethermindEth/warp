//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_signed_le

func warp_le_signed8{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed16{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed24{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed32{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed40{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed48{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed56{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed64{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed72{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed80{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed88{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed96{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed104{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed112{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed120{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed128{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed136{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed144{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed152{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed160{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed168{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed176{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed184{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed192{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed200{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed208{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed216{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed224{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed232{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed240{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed248{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    alloc_locals;
    let (lhs_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (rhs_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;
    if (lhs_msb == 0){
        // lhs >= 0
        if (rhs_msb == 0){
            // rhs >= 0
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }else{
            // rhs < 0
            return (0,);
        }
    }else{
        // lhs < 0
        if (rhs_msb == 0){
            // rhs >= 0
            return (1,);
        }else{
            // rhs < 0
            // (signed) lhs <= rhs <=> (unsigned) lhs >= rhs
            let result = is_le_felt(lhs, rhs);
            return (result,);
        }
    }
}
func warp_le_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt){
    let (res) = uint256_signed_le(lhs, rhs);
    return (res,);
}
