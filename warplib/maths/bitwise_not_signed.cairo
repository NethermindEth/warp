# AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_not
from warplib.types.ints import (
    Int8,
    Int16,
    Int24,
    Int32,
    Int40,
    Int48,
    Int56,
    Int64,
    Int72,
    Int80,
    Int88,
    Int96,
    Int104,
    Int112,
    Int120,
    Int128,
    Int136,
    Int144,
    Int152,
    Int160,
    Int168,
    Int176,
    Int184,
    Int192,
    Int200,
    Int208,
    Int216,
    Int224,
    Int232,
    Int240,
    Int248,
    Int256,
)

func warp_bitwise_not_signed8{bitwise_ptr : BitwiseBuiltin*}(op : Int8) -> (res : Int8):
    let (res) = bitwise_xor(op.value, 0xff)
    return (Int8(value=res))
end
func warp_bitwise_not_signed16{bitwise_ptr : BitwiseBuiltin*}(op : Int16) -> (res : Int16):
    let (res) = bitwise_xor(op.value, 0xffff)
    return (Int16(value=res))
end
func warp_bitwise_not_signed24{bitwise_ptr : BitwiseBuiltin*}(op : Int24) -> (res : Int24):
    let (res) = bitwise_xor(op.value, 0xffffff)
    return (Int24(value=res))
end
func warp_bitwise_not_signed32{bitwise_ptr : BitwiseBuiltin*}(op : Int32) -> (res : Int32):
    let (res) = bitwise_xor(op.value, 0xffffffff)
    return (Int32(value=res))
end
func warp_bitwise_not_signed40{bitwise_ptr : BitwiseBuiltin*}(op : Int40) -> (res : Int40):
    let (res) = bitwise_xor(op.value, 0xffffffffff)
    return (Int40(value=res))
end
func warp_bitwise_not_signed48{bitwise_ptr : BitwiseBuiltin*}(op : Int48) -> (res : Int48):
    let (res) = bitwise_xor(op.value, 0xffffffffffff)
    return (Int48(value=res))
end
func warp_bitwise_not_signed56{bitwise_ptr : BitwiseBuiltin*}(op : Int56) -> (res : Int56):
    let (res) = bitwise_xor(op.value, 0xffffffffffffff)
    return (Int56(value=res))
end
func warp_bitwise_not_signed64{bitwise_ptr : BitwiseBuiltin*}(op : Int64) -> (res : Int64):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffff)
    return (Int64(value=res))
end
func warp_bitwise_not_signed72{bitwise_ptr : BitwiseBuiltin*}(op : Int72) -> (res : Int72):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffff)
    return (Int72(value=res))
end
func warp_bitwise_not_signed80{bitwise_ptr : BitwiseBuiltin*}(op : Int80) -> (res : Int80):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffff)
    return (Int80(value=res))
end
func warp_bitwise_not_signed88{bitwise_ptr : BitwiseBuiltin*}(op : Int88) -> (res : Int88):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffff)
    return (Int88(value=res))
end
func warp_bitwise_not_signed96{bitwise_ptr : BitwiseBuiltin*}(op : Int96) -> (res : Int96):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffff)
    return (Int96(value=res))
end
func warp_bitwise_not_signed104{bitwise_ptr : BitwiseBuiltin*}(op : Int104) -> (res : Int104):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffff)
    return (Int104(value=res))
end
func warp_bitwise_not_signed112{bitwise_ptr : BitwiseBuiltin*}(op : Int112) -> (res : Int112):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffff)
    return (Int112(value=res))
end
func warp_bitwise_not_signed120{bitwise_ptr : BitwiseBuiltin*}(op : Int120) -> (res : Int120):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffff)
    return (Int120(value=res))
end
func warp_bitwise_not_signed128{bitwise_ptr : BitwiseBuiltin*}(op : Int128) -> (res : Int128):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffff)
    return (Int128(value=res))
end
func warp_bitwise_not_signed136{bitwise_ptr : BitwiseBuiltin*}(op : Int136) -> (res : Int136):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffff)
    return (Int136(value=res))
end
func warp_bitwise_not_signed144{bitwise_ptr : BitwiseBuiltin*}(op : Int144) -> (res : Int144):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffff)
    return (Int144(value=res))
end
func warp_bitwise_not_signed152{bitwise_ptr : BitwiseBuiltin*}(op : Int152) -> (res : Int152):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffff)
    return (Int152(value=res))
end
func warp_bitwise_not_signed160{bitwise_ptr : BitwiseBuiltin*}(op : Int160) -> (res : Int160):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffff)
    return (Int160(value=res))
end
func warp_bitwise_not_signed168{bitwise_ptr : BitwiseBuiltin*}(op : Int168) -> (res : Int168):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffff)
    return (Int168(value=res))
end
func warp_bitwise_not_signed176{bitwise_ptr : BitwiseBuiltin*}(op : Int176) -> (res : Int176):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffff)
    return (Int176(value=res))
end
func warp_bitwise_not_signed184{bitwise_ptr : BitwiseBuiltin*}(op : Int184) -> (res : Int184):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int184(value=res))
end
func warp_bitwise_not_signed192{bitwise_ptr : BitwiseBuiltin*}(op : Int192) -> (res : Int192):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int192(value=res))
end
func warp_bitwise_not_signed200{bitwise_ptr : BitwiseBuiltin*}(op : Int200) -> (res : Int200):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int200(value=res))
end
func warp_bitwise_not_signed208{bitwise_ptr : BitwiseBuiltin*}(op : Int208) -> (res : Int208):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int208(value=res))
end
func warp_bitwise_not_signed216{bitwise_ptr : BitwiseBuiltin*}(op : Int216) -> (res : Int216):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int216(value=res))
end
func warp_bitwise_not_signed224{bitwise_ptr : BitwiseBuiltin*}(op : Int224) -> (res : Int224):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int224(value=res))
end
func warp_bitwise_not_signed232{bitwise_ptr : BitwiseBuiltin*}(op : Int232) -> (res : Int232):
    let (res) = bitwise_xor(op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int232(value=res))
end
func warp_bitwise_not_signed240{bitwise_ptr : BitwiseBuiltin*}(op : Int240) -> (res : Int240):
    let (res) = bitwise_xor(
        op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    )
    return (Int240(value=res))
end
func warp_bitwise_not_signed248{bitwise_ptr : BitwiseBuiltin*}(op : Int248) -> (res : Int248):
    let (res) = bitwise_xor(
        op.value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    )
    return (Int248(value=res))
end
func warp_bitwise_not_signed256{range_check_ptr}(op : Int256) -> (res : Int256):
    let (res) = uint256_not(op.value)
    return (Int256(value=res))
end
