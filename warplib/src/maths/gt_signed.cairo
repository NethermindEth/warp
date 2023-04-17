//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_signed_lt
from warplib.maths.lt_signed import warp_lt_signed8, warp_lt_signed16, warp_lt_signed24, warp_lt_signed32, warp_lt_signed40, warp_lt_signed48, warp_lt_signed56, warp_lt_signed64, warp_lt_signed72, warp_lt_signed80, warp_lt_signed88, warp_lt_signed96, warp_lt_signed104, warp_lt_signed112, warp_lt_signed120, warp_lt_signed128, warp_lt_signed136, warp_lt_signed144, warp_lt_signed152, warp_lt_signed160, warp_lt_signed168, warp_lt_signed176, warp_lt_signed184, warp_lt_signed192, warp_lt_signed200, warp_lt_signed208, warp_lt_signed216, warp_lt_signed224, warp_lt_signed232, warp_lt_signed240, warp_lt_signed248

func warp_gt_signed8{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed8(rhs, lhs);
    return (res,);
}
func warp_gt_signed16{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed16(rhs, lhs);
    return (res,);
}
func warp_gt_signed24{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed24(rhs, lhs);
    return (res,);
}
func warp_gt_signed32{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed32(rhs, lhs);
    return (res,);
}
func warp_gt_signed40{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed40(rhs, lhs);
    return (res,);
}
func warp_gt_signed48{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed48(rhs, lhs);
    return (res,);
}
func warp_gt_signed56{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed56(rhs, lhs);
    return (res,);
}
func warp_gt_signed64{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed64(rhs, lhs);
    return (res,);
}
func warp_gt_signed72{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed72(rhs, lhs);
    return (res,);
}
func warp_gt_signed80{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed80(rhs, lhs);
    return (res,);
}
func warp_gt_signed88{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed88(rhs, lhs);
    return (res,);
}
func warp_gt_signed96{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed96(rhs, lhs);
    return (res,);
}
func warp_gt_signed104{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed104(rhs, lhs);
    return (res,);
}
func warp_gt_signed112{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed112(rhs, lhs);
    return (res,);
}
func warp_gt_signed120{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed120(rhs, lhs);
    return (res,);
}
func warp_gt_signed128{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed128(rhs, lhs);
    return (res,);
}
func warp_gt_signed136{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed136(rhs, lhs);
    return (res,);
}
func warp_gt_signed144{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed144(rhs, lhs);
    return (res,);
}
func warp_gt_signed152{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed152(rhs, lhs);
    return (res,);
}
func warp_gt_signed160{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed160(rhs, lhs);
    return (res,);
}
func warp_gt_signed168{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed168(rhs, lhs);
    return (res,);
}
func warp_gt_signed176{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed176(rhs, lhs);
    return (res,);
}
func warp_gt_signed184{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed184(rhs, lhs);
    return (res,);
}
func warp_gt_signed192{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed192(rhs, lhs);
    return (res,);
}
func warp_gt_signed200{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed200(rhs, lhs);
    return (res,);
}
func warp_gt_signed208{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed208(rhs, lhs);
    return (res,);
}
func warp_gt_signed216{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed216(rhs, lhs);
    return (res,);
}
func warp_gt_signed224{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed224(rhs, lhs);
    return (res,);
}
func warp_gt_signed232{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed232(rhs, lhs);
    return (res,);
}
func warp_gt_signed240{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed240(rhs, lhs);
    return (res,);
}
func warp_gt_signed248{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        lhs : felt, rhs : felt) -> (res : felt){
    let (res) = warp_lt_signed248(rhs, lhs);
    return (res,);
}
func warp_gt_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt){
    let (res) =  uint256_signed_lt(rhs, lhs);
    return (res,);
}
