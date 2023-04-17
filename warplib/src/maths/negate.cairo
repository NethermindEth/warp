//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_neg

func warp_negate8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100 - op;
    let (res) = bitwise_and(raw_res, 0xff);
    return (res,);
}
func warp_negate16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000 - op;
    let (res) = bitwise_and(raw_res, 0xffff);
    return (res,);
}
func warp_negate24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffff);
    return (res,);
}
func warp_negate32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffff);
    return (res,);
}
func warp_negate40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffff);
    return (res,);
}
func warp_negate48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffff);
    return (res,);
}
func warp_negate56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffff);
    return (res,);
}
func warp_negate64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffff);
    return (res,);
}
func warp_negate72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffff);
    return (res,);
}
func warp_negate80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffff);
    return (res,);
}
func warp_negate88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_negate96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_negate104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate216{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate224{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate232{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x10000000000000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate240{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x1000000000000000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate248{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let raw_res = 0x100000000000000000000000000000000000000000000000000000000000000 - op;
    let (res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_negate256{range_check_ptr}(op : Uint256) -> (res : Uint256){
    let (res) = uint256_neg(op);
    return (res,);
}
