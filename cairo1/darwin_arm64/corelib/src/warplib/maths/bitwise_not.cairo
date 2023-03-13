//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_not

func warp_bitwise_not8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xff);
    return (res,);
}
func warp_bitwise_not16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffff);
    return (res,);
}
func warp_bitwise_not24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffff);
    return (res,);
}
func warp_bitwise_not32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffff);
    return (res,);
}
func warp_bitwise_not40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffff);
    return (res,);
}
func warp_bitwise_not48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffff);
    return (res,);
}
func warp_bitwise_not56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffff);
    return (res,);
}
func warp_bitwise_not64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffff);
    return (res,);
}
func warp_bitwise_not72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not216{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not224{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not232{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not240{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not248{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_xor(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_bitwise_not256{range_check_ptr}(op : Uint256) -> (res : Uint256){
    let (res) = uint256_not(op);
    return (res,);
}
