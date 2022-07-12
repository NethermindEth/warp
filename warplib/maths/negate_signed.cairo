# AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_neg
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

func warp_negate_signed8{bitwise_ptr : BitwiseBuiltin*}(op : Int8) -> (res : Int8):
    let raw_res = 0x100 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xff)
    return (Int8(value=trunc_res))
end
func warp_negate_signed16{bitwise_ptr : BitwiseBuiltin*}(op : Int16) -> (res : Int16):
    let raw_res = 0x10000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffff)
    return (Int16(value=trunc_res))
end
func warp_negate_signed24{bitwise_ptr : BitwiseBuiltin*}(op : Int24) -> (res : Int24):
    let raw_res = 0x1000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffff)
    return (Int24(value=trunc_res))
end
func warp_negate_signed32{bitwise_ptr : BitwiseBuiltin*}(op : Int32) -> (res : Int32):
    let raw_res = 0x100000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffff)
    return (Int32(value=trunc_res))
end
func warp_negate_signed40{bitwise_ptr : BitwiseBuiltin*}(op : Int40) -> (res : Int40):
    let raw_res = 0x10000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffff)
    return (Int40(value=trunc_res))
end
func warp_negate_signed48{bitwise_ptr : BitwiseBuiltin*}(op : Int48) -> (res : Int48):
    let raw_res = 0x1000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffff)
    return (Int48(value=trunc_res))
end
func warp_negate_signed56{bitwise_ptr : BitwiseBuiltin*}(op : Int56) -> (res : Int56):
    let raw_res = 0x100000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffff)
    return (Int56(value=trunc_res))
end
func warp_negate_signed64{bitwise_ptr : BitwiseBuiltin*}(op : Int64) -> (res : Int64):
    let raw_res = 0x10000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffff)
    return (Int64(value=trunc_res))
end
func warp_negate_signed72{bitwise_ptr : BitwiseBuiltin*}(op : Int72) -> (res : Int72):
    let raw_res = 0x1000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffff)
    return (Int72(value=trunc_res))
end
func warp_negate_signed80{bitwise_ptr : BitwiseBuiltin*}(op : Int80) -> (res : Int80):
    let raw_res = 0x100000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffff)
    return (Int80(value=trunc_res))
end
func warp_negate_signed88{bitwise_ptr : BitwiseBuiltin*}(op : Int88) -> (res : Int88):
    let raw_res = 0x10000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffff)
    return (Int88(value=trunc_res))
end
func warp_negate_signed96{bitwise_ptr : BitwiseBuiltin*}(op : Int96) -> (res : Int96):
    let raw_res = 0x1000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffff)
    return (Int96(value=trunc_res))
end
func warp_negate_signed104{bitwise_ptr : BitwiseBuiltin*}(op : Int104) -> (res : Int104):
    let raw_res = 0x100000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffff)
    return (Int104(value=trunc_res))
end
func warp_negate_signed112{bitwise_ptr : BitwiseBuiltin*}(op : Int112) -> (res : Int112):
    let raw_res = 0x10000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffff)
    return (Int112(value=trunc_res))
end
func warp_negate_signed120{bitwise_ptr : BitwiseBuiltin*}(op : Int120) -> (res : Int120):
    let raw_res = 0x1000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffff)
    return (Int120(value=trunc_res))
end
func warp_negate_signed128{bitwise_ptr : BitwiseBuiltin*}(op : Int128) -> (res : Int128):
    let raw_res = 0x100000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffff)
    return (Int128(value=trunc_res))
end
func warp_negate_signed136{bitwise_ptr : BitwiseBuiltin*}(op : Int136) -> (res : Int136):
    let raw_res = 0x10000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffff)
    return (Int136(value=trunc_res))
end
func warp_negate_signed144{bitwise_ptr : BitwiseBuiltin*}(op : Int144) -> (res : Int144):
    let raw_res = 0x1000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffff)
    return (Int144(value=trunc_res))
end
func warp_negate_signed152{bitwise_ptr : BitwiseBuiltin*}(op : Int152) -> (res : Int152):
    let raw_res = 0x100000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffff)
    return (Int152(value=trunc_res))
end
func warp_negate_signed160{bitwise_ptr : BitwiseBuiltin*}(op : Int160) -> (res : Int160):
    let raw_res = 0x10000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffff)
    return (Int160(value=trunc_res))
end
func warp_negate_signed168{bitwise_ptr : BitwiseBuiltin*}(op : Int168) -> (res : Int168):
    let raw_res = 0x1000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffff)
    return (Int168(value=trunc_res))
end
func warp_negate_signed176{bitwise_ptr : BitwiseBuiltin*}(op : Int176) -> (res : Int176):
    let raw_res = 0x100000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffff)
    return (Int176(value=trunc_res))
end
func warp_negate_signed184{bitwise_ptr : BitwiseBuiltin*}(op : Int184) -> (res : Int184):
    let raw_res = 0x10000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int184(value=trunc_res))
end
func warp_negate_signed192{bitwise_ptr : BitwiseBuiltin*}(op : Int192) -> (res : Int192):
    let raw_res = 0x1000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int192(value=trunc_res))
end
func warp_negate_signed200{bitwise_ptr : BitwiseBuiltin*}(op : Int200) -> (res : Int200):
    let raw_res = 0x100000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int200(value=trunc_res))
end
func warp_negate_signed208{bitwise_ptr : BitwiseBuiltin*}(op : Int208) -> (res : Int208):
    let raw_res = 0x10000000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int208(value=trunc_res))
end
func warp_negate_signed216{bitwise_ptr : BitwiseBuiltin*}(op : Int216) -> (res : Int216):
    let raw_res = 0x1000000000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    return (Int216(value=trunc_res))
end
func warp_negate_signed224{bitwise_ptr : BitwiseBuiltin*}(op : Int224) -> (res : Int224):
    let raw_res = 0x100000000000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(
        raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    )
    return (Int224(value=trunc_res))
end
func warp_negate_signed232{bitwise_ptr : BitwiseBuiltin*}(op : Int232) -> (res : Int232):
    let raw_res = 0x10000000000000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(
        raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    )
    return (Int232(value=trunc_res))
end
func warp_negate_signed240{bitwise_ptr : BitwiseBuiltin*}(op : Int240) -> (res : Int240):
    let raw_res = 0x1000000000000000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(
        raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    )
    return (Int240(value=trunc_res))
end
func warp_negate_signed248{bitwise_ptr : BitwiseBuiltin*}(op : Int248) -> (res : Int248):
    let raw_res = 0x100000000000000000000000000000000000000000000000000000000000000 - op.value
    let (trunc_res) = bitwise_and(
        raw_res, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    )
    return (Int248(value=trunc_res))
end
func warp_negate_signed256{range_check_ptr}(op : Int256) -> (res : Int256):
    let (res : Uint256) = uint256_neg(op.value)
    return (Int256(value=res))
end
