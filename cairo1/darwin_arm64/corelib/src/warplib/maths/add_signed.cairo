//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_add

func warp_add_signed8{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80);
    let (rmsb) = bitwise_and(rhs, 0x80);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180);
    assert overflowBits * (overflowBits - 0x180) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xff);
    return (res,);
}
func warp_add_signed16{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000);
    let (rmsb) = bitwise_and(rhs, 0x8000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000);
    assert overflowBits * (overflowBits - 0x18000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffff);
    return (res,);
}
func warp_add_signed24{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000);
    let (rmsb) = bitwise_and(rhs, 0x800000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000);
    assert overflowBits * (overflowBits - 0x1800000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffff);
    return (res,);
}
func warp_add_signed32{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000);
    assert overflowBits * (overflowBits - 0x180000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffff);
    return (res,);
}
func warp_add_signed40{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000);
    assert overflowBits * (overflowBits - 0x18000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffff);
    return (res,);
}
func warp_add_signed48{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000);
    assert overflowBits * (overflowBits - 0x1800000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffff);
    return (res,);
}
func warp_add_signed56{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffff);
    return (res,);
}
func warp_add_signed64{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffff);
    return (res,);
}
func warp_add_signed72{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffff);
    return (res,);
}
func warp_add_signed80{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffff);
    return (res,);
}
func warp_add_signed88{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed96{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed104{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed112{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed120{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed128{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed136{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed144{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed152{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed160{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed168{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed176{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed184{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed192{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed200{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed208{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed216{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed224{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed232{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x18000000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed240{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x1800000000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed248{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
// Do the addition sign extended
    let (lmsb) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (rmsb) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let big_res = lhs + rhs + 2*(lmsb+rmsb);
// Check the result is valid
    let (overflowBits) = bitwise_and(big_res,  0x180000000000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000000000000000000000) = 0;
// Truncate and return
    let (res) =  bitwise_and(big_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_add_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        lhs : Uint256, rhs : Uint256) -> (res : Uint256){
    let (lhs_extend) = bitwise_and(lhs.high, 0x80000000000000000000000000000000);
    let (rhs_extend) = bitwise_and(rhs.high, 0x80000000000000000000000000000000);
    let (res : Uint256, carry : felt) = uint256_add(lhs, rhs);
    let carry_extend = lhs_extend + rhs_extend + carry*0x80000000000000000000000000000000;
    let (msb) = bitwise_and(res.high, 0x80000000000000000000000000000000);
    let (carry_lsb) = bitwise_and(carry_extend, 0x80000000000000000000000000000000);
    assert msb = carry_lsb;
    return (res,);
}
