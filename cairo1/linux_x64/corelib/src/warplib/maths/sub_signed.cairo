//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_signed_le, uint256_sub, uint256_not

func warp_sub_signed8{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80);
    let (right_msb : felt) = bitwise_and(rhs, 0x80);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180);
    assert overflowBits * (overflowBits - 0x180) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xff);
    return (res,);
}
func warp_sub_signed16{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000);
    assert overflowBits * (overflowBits - 0x18000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffff);
    return (res,);
}
func warp_sub_signed24{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000);
    assert overflowBits * (overflowBits - 0x1800000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffff);
    return (res,);
}
func warp_sub_signed32{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000);
    assert overflowBits * (overflowBits - 0x180000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffff);
    return (res,);
}
func warp_sub_signed40{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000);
    assert overflowBits * (overflowBits - 0x18000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffff);
    return (res,);
}
func warp_sub_signed48{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000);
    assert overflowBits * (overflowBits - 0x1800000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffff);
    return (res,);
}
func warp_sub_signed56{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffff);
    return (res,);
}
func warp_sub_signed64{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffff);
    return (res,);
}
func warp_sub_signed72{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffff);
    return (res,);
}
func warp_sub_signed80{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed88{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed96{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed104{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed112{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed120{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed128{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed136{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed144{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed152{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed160{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed168{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed176{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed184{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed192{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed200{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed208{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed216{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed224{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed232{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x18000000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x18000000000000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed240{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x1800000000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x1800000000000000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed248{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (
        res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Check if the result fits in the correct width
    let (overflowBits) = bitwise_and(extended_res, 0x180000000000000000000000000000000000000000000000000000000000000);
    assert overflowBits * (overflowBits - 0x180000000000000000000000000000000000000000000000000000000000000) = 0;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (
        res : Uint256){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs.high, 0x80000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs.high, 0x80000000000000000000000000000000);
    let left_overflow : felt = left_msb / 0x80000000000000000000000000000000;
    let right_overflow : felt = right_msb / 0x80000000000000000000000000000000;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let (right_flipped : Uint256) = uint256_not(rhs);
    let (right_neg, overflow) = uint256_add(right_flipped, Uint256(1,0));
    let right_overflow_neg = overflow + 1 - right_overflow;
    let (res, res_base_overflow) = uint256_add(lhs, right_neg);
    let res_overflow = res_base_overflow + left_overflow + right_overflow_neg;

    // Check if the result fits in the correct width
    let (res_msb : felt) = bitwise_and(res.high, 0x80000000000000000000000000000000);
    let (res_overflow_lsb : felt) = bitwise_and(res_overflow, 1);
    assert res_overflow_lsb * 0x80000000000000000000000000000000 = res_msb;

    // Narrow and return
    return (res,);
}
