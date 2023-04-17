//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_sub

func warp_sub_signed_unsafe8{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80);
    let (right_msb : felt) = bitwise_and(rhs, 0x80);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xff);
    return (res,);
}
func warp_sub_signed_unsafe16{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffff);
    return (res,);
}
func warp_sub_signed_unsafe24{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffff);
    return (res,);
}
func warp_sub_signed_unsafe32{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffff);
    return (res,);
}
func warp_sub_signed_unsafe40{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe48{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe56{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe64{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe72{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe80{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe88{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe96{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe104{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe112{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe120{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe128{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe136{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe144{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe152{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe160{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe168{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe176{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe184{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe192{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe200{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe208{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe216{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe224{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe232{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x8000000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x20000000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe240{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x800000000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x2000000000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe248{bitwise_ptr : BitwiseBuiltin*}(
        lhs : felt, rhs : felt) -> (res : felt){
    // First sign extend both operands
    let (left_msb : felt) = bitwise_and(lhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (right_msb : felt) = bitwise_and(rhs, 0x80000000000000000000000000000000000000000000000000000000000000);
    let left_safe : felt = lhs + 2 * left_msb;
    let right_safe : felt = rhs + 2 * right_msb;

    // Now safely negate the rhs and add (l - r = l + (-r))
    let right_neg : felt = 0x200000000000000000000000000000000000000000000000000000000000000 - right_safe;
    let extended_res : felt = left_safe + right_neg;

    // Narrow and return
    let (res) = bitwise_and(extended_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_sub_signed_unsafe256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){
    let (res) =  uint256_sub(lhs, rhs);
    return (res,);
}
