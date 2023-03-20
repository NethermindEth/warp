//AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.uint256 import Uint256, uint256_add


func warp_int8_to_int16{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00,);
    }
}
func warp_int8_to_int24{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00,);
    }
}
func warp_int8_to_int32{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00,);
    }
}
func warp_int8_to_int40{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00,);
    }
}
func warp_int8_to_int48{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00,);
    }
}
func warp_int8_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00,);
    }
}
func warp_int8_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00,);
    }
}
func warp_int8_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00,);
    }
}
func warp_int8_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00,);
    }
}
func warp_int8_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00,);
    }
}
func warp_int8_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00,);
    }
}
func warp_int8_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffffffffffffffff00, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int16_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}

func warp_int16_to_int24{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000,);
    }
}
func warp_int16_to_int32{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000,);
    }
}
func warp_int16_to_int40{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000,);
    }
}
func warp_int16_to_int48{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000,);
    }
}
func warp_int16_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000,);
    }
}
func warp_int16_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000,);
    }
}
func warp_int16_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000,);
    }
}
func warp_int16_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000,);
    }
}
func warp_int16_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000,);
    }
}
func warp_int16_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000,);
    }
}
func warp_int16_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffffffffffffff0000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int24_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int24_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}

func warp_int24_to_int32{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000,);
    }
}
func warp_int24_to_int40{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000,);
    }
}
func warp_int24_to_int48{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000,);
    }
}
func warp_int24_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000,);
    }
}
func warp_int24_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000,);
    }
}
func warp_int24_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000,);
    }
}
func warp_int24_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000,);
    }
}
func warp_int24_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000,);
    }
}
func warp_int24_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000,);
    }
}
func warp_int24_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000,);
    }
}
func warp_int24_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffffffffffff000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int32_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int32_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int32_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}

func warp_int32_to_int40{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000,);
    }
}
func warp_int32_to_int48{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000,);
    }
}
func warp_int32_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000,);
    }
}
func warp_int32_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000,);
    }
}
func warp_int32_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000,);
    }
}
func warp_int32_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000,);
    }
}
func warp_int32_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000,);
    }
}
func warp_int32_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000,);
    }
}
func warp_int32_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000,);
    }
}
func warp_int32_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffffffffff00000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int40_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int40_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int40_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int40_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}

func warp_int40_to_int48{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000,);
    }
}
func warp_int40_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000,);
    }
}
func warp_int40_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000,);
    }
}
func warp_int40_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000,);
    }
}
func warp_int40_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000,);
    }
}
func warp_int40_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000,);
    }
}
func warp_int40_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000,);
    }
}
func warp_int40_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000,);
    }
}
func warp_int40_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffffffff0000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int48_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int48_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int48_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int48_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int48_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}

func warp_int48_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000,);
    }
}
func warp_int48_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000,);
    }
}
func warp_int48_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000,);
    }
}
func warp_int48_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000,);
    }
}
func warp_int48_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000,);
    }
}
func warp_int48_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000,);
    }
}
func warp_int48_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000,);
    }
}
func warp_int48_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffffff000000000000,);
    }
}
func warp_int48_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffffff000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int56_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int56_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int56_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int56_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int56_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int56_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}

func warp_int56_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000,);
    }
}
func warp_int56_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000,);
    }
}
func warp_int56_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000,);
    }
}
func warp_int56_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000,);
    }
}
func warp_int56_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000,);
    }
}
func warp_int56_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000,);
    }
}
func warp_int56_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffffff00000000000000,);
    }
}
func warp_int56_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffffff00000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int64_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int64_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int64_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int64_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int64_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int64_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int64_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}

func warp_int64_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000,);
    }
}
func warp_int64_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000,);
    }
}
func warp_int64_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000,);
    }
}
func warp_int64_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000,);
    }
}
func warp_int64_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000,);
    }
}
func warp_int64_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffffff0000000000000000,);
    }
}
func warp_int64_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffffff0000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int72_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int72_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int72_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int72_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int72_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int72_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int72_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int72_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}

func warp_int72_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000,);
    }
}
func warp_int72_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000,);
    }
}
func warp_int72_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000,);
    }
}
func warp_int72_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000,);
    }
}
func warp_int72_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000000000,);
    }
}
func warp_int72_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffffff000000000000000000,);
    }
}
func warp_int72_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffffff000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int80_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int80_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int80_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int80_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int80_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int80_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int80_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int80_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int80_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}

func warp_int80_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000,);
    }
}
func warp_int80_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000,);
    }
}
func warp_int80_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000,);
    }
}
func warp_int80_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000000000,);
    }
}
func warp_int80_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffffff00000000000000000000,);
    }
}
func warp_int80_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffffff00000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int88_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int88_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int88_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int88_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int88_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int88_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int88_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int88_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int88_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int88_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}

func warp_int88_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000,);
    }
}
func warp_int88_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000,);
    }
}
func warp_int88_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000000000,);
    }
}
func warp_int88_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffffff0000000000000000000000,);
    }
}
func warp_int88_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffffff0000000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int96_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int96_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int96_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int96_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int96_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int96_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int96_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int96_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int96_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int96_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int96_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}

func warp_int96_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000,);
    }
}
func warp_int96_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000000000,);
    }
}
func warp_int96_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000000000,);
    }
}
func warp_int96_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffffff000000000000000000000000,);
    }
}
func warp_int96_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffffff000000000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int104_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int104_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int104_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int104_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int104_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int104_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int104_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int104_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int104_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int104_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int104_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int104_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}

func warp_int104_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000000000,);
    }
}
func warp_int104_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000000000,);
    }
}
func warp_int104_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffffff00000000000000000000000000,);
    }
}
func warp_int104_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffffff00000000000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int112_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int112_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int112_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int112_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int112_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int112_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int112_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int112_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int112_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int112_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int112_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int112_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int112_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}

func warp_int112_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000000000,);
    }
}
func warp_int112_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffffff0000000000000000000000000000,);
    }
}
func warp_int112_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xffff0000000000000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int120_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int120_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int120_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int120_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int120_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int120_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int120_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int120_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int120_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int120_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int120_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int120_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int120_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int120_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int120_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000000000,);
    }
}
func warp_int120_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffffff000000000000000000000000000000,);
    }
}
func warp_int120_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0xff000000000000000000000000000000, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int128_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int128_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int128_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int128_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int128_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int128_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int128_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int128_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int128_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int128_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int128_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int128_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int128_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int128_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int128_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int128_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffffff00000000000000000000000000000000,);
    }
}
func warp_int128_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffffffffffffffff));
        return (res,);
    }
}
func warp_int136_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int136_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int136_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int136_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int136_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int136_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int136_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int136_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int136_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int136_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int136_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffffff0000000000000000000000000000000000,);
    }
}
func warp_int136_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffffffffffffff00));
        return (res,);
    }
}
func warp_int144_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int144_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int144_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int144_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int144_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int144_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int144_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int144_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int144_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int144_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int144_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffffff000000000000000000000000000000000000,);
    }
}
func warp_int144_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffffffffffff0000));
        return (res,);
    }
}
func warp_int152_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int152_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int152_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int152_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int152_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int152_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int152_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int152_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int152_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int152_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int152_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffffff00000000000000000000000000000000000000,);
    }
}
func warp_int152_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffffffffff000000));
        return (res,);
    }
}
func warp_int160_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int160_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int160_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int160_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int160_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int160_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int160_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int160_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int160_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int160_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int160_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffffff0000000000000000000000000000000000000000,);
    }
}
func warp_int160_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffffffff00000000));
        return (res,);
    }
}
func warp_int168_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int168_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int168_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int168_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int168_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int168_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int168_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int168_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int168_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int168_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int168_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffffff000000000000000000000000000000000000000000,);
    }
}
func warp_int168_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffffff0000000000));
        return (res,);
    }
}
func warp_int176_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int176_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int176_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int176_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int176_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int176_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int176_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int176_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int176_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int176_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int176_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffffff00000000000000000000000000000000000000000000,);
    }
}
func warp_int176_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffffff000000000000));
        return (res,);
    }
}
func warp_int184_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int184_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int184_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int184_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int184_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int184_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int184_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int184_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int184_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int184_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int184_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffffff0000000000000000000000000000000000000000000000,);
    }
}
func warp_int184_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffffff00000000000000));
        return (res,);
    }
}
func warp_int192_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int192_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int192_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int192_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int192_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int192_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int192_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int192_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int192_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int192_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int192_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffffff000000000000000000000000000000000000000000000000,);
    }
}
func warp_int192_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffffff0000000000000000));
        return (res,);
    }
}
func warp_int200_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int200_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int200_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int200_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int200_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int200_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int200_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int200_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int200_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int200_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int200_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000000000000000000000000000000000,);
    }
}
func warp_int200_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000000000000000000000000000000000,);
    }
}
func warp_int200_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000000000000000000000000000000000,);
    }
}
func warp_int200_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff00000000000000000000000000000000000000000000000000,);
    }
}
func warp_int200_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff00000000000000000000000000000000000000000000000000,);
    }
}
func warp_int200_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffffff00000000000000000000000000000000000000000000000000,);
    }
}
func warp_int200_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffffff000000000000000000));
        return (res,);
    }
}
func warp_int208_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int208_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int208_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int208_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int208_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int208_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int208_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int208_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int208_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int208_to_int200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int208_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int208_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int208_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff0000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int208_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff0000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int208_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffffff0000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int208_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffffff00000000000000000000));
        return (res,);
    }
}
func warp_int216_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int216_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int216_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int216_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int216_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int216_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int216_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int216_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int216_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int216_to_int208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int216_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int216_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int216_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int216_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffffff000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int216_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffffff0000000000000000000000));
        return (res,);
    }
}
func warp_int224_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int224_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int224_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int224_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int224_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int224_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int224_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int224_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int224_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int224_to_int216{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int224_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff00000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int224_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff00000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int224_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffffff00000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int224_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffffff000000000000000000000000));
        return (res,);
    }
}
func warp_int232_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int232_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int232_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int232_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int232_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int232_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int232_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int232_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int232_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int216{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int232_to_int224{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int232_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff0000000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int232_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xffff0000000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int232_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x8000000000000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffffff00000000000000000000000000));
        return (res,);
    }
}
func warp_int240_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int240_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int240_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int240_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int240_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int240_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int240_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int240_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int240_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int216{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int224{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int240_to_int232{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int240_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000000000);
    if (msb == 0){
        return (op,);
    }else{
        return (op + 0xff000000000000000000000000000000000000000000000000000000000000,);
    }
}
func warp_int240_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x800000000000000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xffff0000000000000000000000000000));
        return (res,);
    }
}
func warp_int248_to_int8{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xff);
    return (res,);
}
func warp_int248_to_int16{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffff);
    return (res,);
}
func warp_int248_to_int24{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffff);
    return (res,);
}
func warp_int248_to_int32{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffff);
    return (res,);
}
func warp_int248_to_int40{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffff);
    return (res,);
}
func warp_int248_to_int48{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffff);
    return (res,);
}
func warp_int248_to_int56{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffff);
    return (res,);
}
func warp_int248_to_int64{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffff);
    return (res,);
}
func warp_int248_to_int72{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int80{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int88{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int96{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int104{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int112{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int120{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int128{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int136{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int144{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int152{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int160{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int168{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int176{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int184{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int192{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int200{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int208{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int216{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int224{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int232{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int248_to_int240{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){
    let (res) = bitwise_and(op, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    return (res,);
}

func warp_int248_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){
    let (msb) = bitwise_and(op, 0x80000000000000000000000000000000000000000000000000000000000000);
    let (high, low) = split_felt(op);
    let naiveExtension = Uint256(low, high);
    if (msb == 0){
        return (naiveExtension,);
    }else{
        let (res, _) = uint256_add(naiveExtension, Uint256(0x0, 0xff000000000000000000000000000000));
        return (res,);
    }
}
func warp_int256_to_int8{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xff);
    return (res,);
}
func warp_int256_to_int16{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffff);
    return (res,);
}
func warp_int256_to_int24{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffff);
    return (res,);
}
func warp_int256_to_int32{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffff);
    return (res,);
}
func warp_int256_to_int40{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffff);
    return (res,);
}
func warp_int256_to_int48{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffff);
    return (res,);
}
func warp_int256_to_int56{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffff);
    return (res,);
}
func warp_int256_to_int64{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffff);
    return (res,);
}
func warp_int256_to_int72{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int80{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int88{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int96{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int104{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int112{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int120{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int128{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (res) = bitwise_and(op.low, 0xffffffffffffffffffffffffffffffff);
    return (res,);
}
func warp_int256_to_int136{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int144{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int152{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int160{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int168{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int176{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int184{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int192{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int200{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int208{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int216{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int224{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int232{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int240{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}
func warp_int256_to_int248{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){
    let (high) = bitwise_and(op.high,0xffffffffffffffffffffffffffffff);
    return (op.low + 0x100000000000000000000000000000000 * high,);
}

func warp_uint256{range_check_ptr}(op : felt) -> (res : Uint256){
    let split = split_felt(op);
    return (Uint256(low=split.low, high=split.high),);
}
