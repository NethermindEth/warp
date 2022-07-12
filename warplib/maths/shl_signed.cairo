# AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_shl
from warplib.types.uints import (
    Uint8,
    Uint16,
    Uint24,
    Uint32,
    Uint40,
    Uint48,
    Uint56,
    Uint64,
    Uint72,
    Uint80,
    Uint88,
    Uint96,
    Uint104,
    Uint112,
    Uint120,
    Uint128,
    Uint136,
    Uint144,
    Uint152,
    Uint160,
    Uint168,
    Uint176,
    Uint184,
    Uint192,
    Uint200,
    Uint208,
    Uint216,
    Uint224,
    Uint232,
    Uint240,
    Uint248,
)
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
from warplib.maths.pow2 import pow2

func warp_shl_signed8_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint8
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint16
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint24
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint32
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint40
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint48
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint56
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint64
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint72
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint80
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint88
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint96
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint104
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint112
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint120
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint128
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint136
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint144
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint152
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint160
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint168
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint176
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint184
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint192
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint200
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint208
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint216
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint224
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint232
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint240
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint248
) -> (res : Int8):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(8, rhs.value)
    if large_shift == 1:
        return (Int8(0))
    else:
        let preserved_width = 8 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int8(value=res))
    end
end
func warp_shl_signed8_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int8, rhs : Uint256
) -> (res : Int8):
    if rhs.high == 0:
        let (res) = warp_shl_signed8_8(lhs, Uint8(rhs.low))
        return (res)
    else:
        return (Int8(value=0))
    end
end
func warp_shl_signed16_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint8
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint16
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint24
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint32
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint40
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint48
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint56
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint64
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint72
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint80
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint88
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint96
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint104
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint112
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint120
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint128
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint136
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint144
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint152
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint160
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint168
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint176
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint184
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint192
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint200
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint208
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint216
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint224
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint232
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint240
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint248
) -> (res : Int16):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(16, rhs.value)
    if large_shift == 1:
        return (Int16(0))
    else:
        let preserved_width = 16 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int16(value=res))
    end
end
func warp_shl_signed16_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int16, rhs : Uint256
) -> (res : Int16):
    if rhs.high == 0:
        let (res) = warp_shl_signed16_16(lhs, Uint16(rhs.low))
        return (res)
    else:
        return (Int16(value=0))
    end
end
func warp_shl_signed24_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint8
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint16
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint24
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint32
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint40
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint48
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint56
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint64
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint72
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint80
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint88
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint96
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint104
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint112
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint120
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint128
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint136
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint144
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint152
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint160
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint168
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint176
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint184
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint192
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint200
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint208
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint216
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint224
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint232
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint240
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint248
) -> (res : Int24):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(24, rhs.value)
    if large_shift == 1:
        return (Int24(0))
    else:
        let preserved_width = 24 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int24(value=res))
    end
end
func warp_shl_signed24_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int24, rhs : Uint256
) -> (res : Int24):
    if rhs.high == 0:
        let (res) = warp_shl_signed24_24(lhs, Uint24(rhs.low))
        return (res)
    else:
        return (Int24(value=0))
    end
end
func warp_shl_signed32_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint8
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint16
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint24
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint32
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint40
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint48
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint56
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint64
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint72
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint80
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint88
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint96
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint104
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint112
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint120
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint128
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint136
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint144
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint152
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint160
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint168
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint176
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint184
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint192
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint200
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint208
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint216
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint224
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint232
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint240
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint248
) -> (res : Int32):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(32, rhs.value)
    if large_shift == 1:
        return (Int32(0))
    else:
        let preserved_width = 32 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int32(value=res))
    end
end
func warp_shl_signed32_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int32, rhs : Uint256
) -> (res : Int32):
    if rhs.high == 0:
        let (res) = warp_shl_signed32_32(lhs, Uint32(rhs.low))
        return (res)
    else:
        return (Int32(value=0))
    end
end
func warp_shl_signed40_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint8
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint16
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint24
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint32
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint40
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint48
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint56
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint64
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint72
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint80
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint88
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint96
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint104
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint112
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint120
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint128
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint136
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint144
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint152
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint160
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint168
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint176
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint184
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint192
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint200
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint208
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint216
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint224
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint232
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint240
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint248
) -> (res : Int40):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(40, rhs.value)
    if large_shift == 1:
        return (Int40(0))
    else:
        let preserved_width = 40 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int40(value=res))
    end
end
func warp_shl_signed40_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int40, rhs : Uint256
) -> (res : Int40):
    if rhs.high == 0:
        let (res) = warp_shl_signed40_40(lhs, Uint40(rhs.low))
        return (res)
    else:
        return (Int40(value=0))
    end
end
func warp_shl_signed48_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint8
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint16
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint24
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint32
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint40
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint48
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint56
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint64
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint72
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint80
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint88
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint96
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint104
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint112
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint120
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint128
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint136
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint144
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint152
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint160
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint168
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint176
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint184
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint192
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint200
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint208
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint216
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint224
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint232
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint240
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint248
) -> (res : Int48):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(48, rhs.value)
    if large_shift == 1:
        return (Int48(0))
    else:
        let preserved_width = 48 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int48(value=res))
    end
end
func warp_shl_signed48_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int48, rhs : Uint256
) -> (res : Int48):
    if rhs.high == 0:
        let (res) = warp_shl_signed48_48(lhs, Uint48(rhs.low))
        return (res)
    else:
        return (Int48(value=0))
    end
end
func warp_shl_signed56_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint8
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint16
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint24
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint32
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint40
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint48
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint56
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint64
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint72
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint80
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint88
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint96
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint104
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint112
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint120
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint128
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint136
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint144
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint152
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint160
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint168
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint176
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint184
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint192
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint200
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint208
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint216
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint224
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint232
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint240
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint248
) -> (res : Int56):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(56, rhs.value)
    if large_shift == 1:
        return (Int56(0))
    else:
        let preserved_width = 56 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int56(value=res))
    end
end
func warp_shl_signed56_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int56, rhs : Uint256
) -> (res : Int56):
    if rhs.high == 0:
        let (res) = warp_shl_signed56_56(lhs, Uint56(rhs.low))
        return (res)
    else:
        return (Int56(value=0))
    end
end
func warp_shl_signed64_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint8
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint16
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint24
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint32
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint40
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint48
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint56
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint64
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint72
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint80
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint88
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint96
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint104
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint112
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint120
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint128
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint136
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint144
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint152
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint160
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint168
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint176
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint184
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint192
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint200
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint208
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint216
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint224
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint232
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint240
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint248
) -> (res : Int64):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(64, rhs.value)
    if large_shift == 1:
        return (Int64(0))
    else:
        let preserved_width = 64 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int64(value=res))
    end
end
func warp_shl_signed64_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int64, rhs : Uint256
) -> (res : Int64):
    if rhs.high == 0:
        let (res) = warp_shl_signed64_64(lhs, Uint64(rhs.low))
        return (res)
    else:
        return (Int64(value=0))
    end
end
func warp_shl_signed72_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint8
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint16
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint24
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint32
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint40
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint48
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint56
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint64
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint72
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint80
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint88
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint96
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint104
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint112
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint120
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint128
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint136
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint144
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint152
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint160
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint168
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint176
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint184
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint192
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint200
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint208
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint216
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint224
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint232
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint240
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint248
) -> (res : Int72):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(72, rhs.value)
    if large_shift == 1:
        return (Int72(0))
    else:
        let preserved_width = 72 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int72(value=res))
    end
end
func warp_shl_signed72_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int72, rhs : Uint256
) -> (res : Int72):
    if rhs.high == 0:
        let (res) = warp_shl_signed72_72(lhs, Uint72(rhs.low))
        return (res)
    else:
        return (Int72(value=0))
    end
end
func warp_shl_signed80_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint8
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint16
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint24
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint32
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint40
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint48
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint56
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint64
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint72
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint80
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint88
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint96
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint104
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint112
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint120
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint128
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint136
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint144
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint152
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint160
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint168
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint176
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint184
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint192
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint200
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint208
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint216
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint224
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint232
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint240
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint248
) -> (res : Int80):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(80, rhs.value)
    if large_shift == 1:
        return (Int80(0))
    else:
        let preserved_width = 80 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int80(value=res))
    end
end
func warp_shl_signed80_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int80, rhs : Uint256
) -> (res : Int80):
    if rhs.high == 0:
        let (res) = warp_shl_signed80_80(lhs, Uint80(rhs.low))
        return (res)
    else:
        return (Int80(value=0))
    end
end
func warp_shl_signed88_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint8
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint16
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint24
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint32
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint40
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint48
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint56
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint64
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint72
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint80
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint88
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint96
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint104
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint112
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint120
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint128
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint136
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint144
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint152
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint160
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint168
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint176
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint184
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint192
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint200
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint208
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint216
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint224
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint232
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint240
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint248
) -> (res : Int88):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(88, rhs.value)
    if large_shift == 1:
        return (Int88(0))
    else:
        let preserved_width = 88 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int88(value=res))
    end
end
func warp_shl_signed88_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int88, rhs : Uint256
) -> (res : Int88):
    if rhs.high == 0:
        let (res) = warp_shl_signed88_88(lhs, Uint88(rhs.low))
        return (res)
    else:
        return (Int88(value=0))
    end
end
func warp_shl_signed96_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint8
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint16
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint24
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint32
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint40
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint48
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint56
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint64
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint72
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint80
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint88
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint96
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint104
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint112
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint120
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint128
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint136
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint144
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint152
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint160
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint168
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint176
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint184
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint192
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint200
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint208
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint216
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint224
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint232
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint240
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint248
) -> (res : Int96):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(96, rhs.value)
    if large_shift == 1:
        return (Int96(0))
    else:
        let preserved_width = 96 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int96(value=res))
    end
end
func warp_shl_signed96_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int96, rhs : Uint256
) -> (res : Int96):
    if rhs.high == 0:
        let (res) = warp_shl_signed96_96(lhs, Uint96(rhs.low))
        return (res)
    else:
        return (Int96(value=0))
    end
end
func warp_shl_signed104_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint8
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint16
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint24
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint32
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint40
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint48
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint56
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint64
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint72
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint80
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint88
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint96
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint104
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint112
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint120
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint128
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint136
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint144
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint152
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint160
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint168
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint176
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint184
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint192
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint200
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint208
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint216
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint224
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint232
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint240
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint248
) -> (res : Int104):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(104, rhs.value)
    if large_shift == 1:
        return (Int104(0))
    else:
        let preserved_width = 104 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int104(value=res))
    end
end
func warp_shl_signed104_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int104, rhs : Uint256
) -> (res : Int104):
    if rhs.high == 0:
        let (res) = warp_shl_signed104_104(lhs, Uint104(rhs.low))
        return (res)
    else:
        return (Int104(value=0))
    end
end
func warp_shl_signed112_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint8
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint16
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint24
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint32
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint40
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint48
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint56
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint64
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint72
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint80
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint88
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint96
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint104
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint112
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint120
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint128
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint136
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint144
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint152
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint160
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint168
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint176
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint184
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint192
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint200
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint208
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint216
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint224
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint232
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint240
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint248
) -> (res : Int112):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(112, rhs.value)
    if large_shift == 1:
        return (Int112(0))
    else:
        let preserved_width = 112 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int112(value=res))
    end
end
func warp_shl_signed112_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int112, rhs : Uint256
) -> (res : Int112):
    if rhs.high == 0:
        let (res) = warp_shl_signed112_112(lhs, Uint112(rhs.low))
        return (res)
    else:
        return (Int112(value=0))
    end
end
func warp_shl_signed120_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint8
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint16
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint24
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint32
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint40
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint48
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint56
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint64
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint72
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint80
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint88
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint96
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint104
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint112
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint120
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint128
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint136
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint144
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint152
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint160
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint168
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint176
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint184
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint192
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint200
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint208
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint216
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint224
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint232
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint240
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint248
) -> (res : Int120):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(120, rhs.value)
    if large_shift == 1:
        return (Int120(0))
    else:
        let preserved_width = 120 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int120(value=res))
    end
end
func warp_shl_signed120_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int120, rhs : Uint256
) -> (res : Int120):
    if rhs.high == 0:
        let (res) = warp_shl_signed120_120(lhs, Uint120(rhs.low))
        return (res)
    else:
        return (Int120(value=0))
    end
end
func warp_shl_signed128_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint8
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint16
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint24
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint32
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint40
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint48
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint56
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint64
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint72
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint80
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint88
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint96
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint104
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint112
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint120
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint128
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint136
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint144
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint152
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint160
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint168
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint176
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint184
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint192
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint200
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint208
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint216
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint224
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint232
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint240
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint248
) -> (res : Int128):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(128, rhs.value)
    if large_shift == 1:
        return (Int128(0))
    else:
        let preserved_width = 128 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int128(value=res))
    end
end
func warp_shl_signed128_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int128, rhs : Uint256
) -> (res : Int128):
    if rhs.high == 0:
        let (res) = warp_shl_signed128_128(lhs, Uint128(rhs.low))
        return (res)
    else:
        return (Int128(value=0))
    end
end
func warp_shl_signed136_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint8
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint16
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint24
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint32
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint40
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint48
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint56
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint64
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint72
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint80
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint88
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint96
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint104
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint112
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint120
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint128
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint136
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint144
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint152
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint160
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint168
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint176
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint184
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint192
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint200
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint208
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint216
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint224
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint232
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint240
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint248
) -> (res : Int136):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(136, rhs.value)
    if large_shift == 1:
        return (Int136(0))
    else:
        let preserved_width = 136 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int136(value=res))
    end
end
func warp_shl_signed136_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int136, rhs : Uint256
) -> (res : Int136):
    if rhs.high == 0:
        let (res) = warp_shl_signed136_136(lhs, Uint136(rhs.low))
        return (res)
    else:
        return (Int136(value=0))
    end
end
func warp_shl_signed144_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint8
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint16
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint24
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint32
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint40
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint48
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint56
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint64
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint72
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint80
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint88
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint96
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint104
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint112
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint120
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint128
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint136
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint144
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint152
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint160
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint168
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint176
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint184
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint192
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint200
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint208
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint216
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint224
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint232
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint240
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint248
) -> (res : Int144):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(144, rhs.value)
    if large_shift == 1:
        return (Int144(0))
    else:
        let preserved_width = 144 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int144(value=res))
    end
end
func warp_shl_signed144_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int144, rhs : Uint256
) -> (res : Int144):
    if rhs.high == 0:
        let (res) = warp_shl_signed144_144(lhs, Uint144(rhs.low))
        return (res)
    else:
        return (Int144(value=0))
    end
end
func warp_shl_signed152_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint8
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint16
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint24
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint32
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint40
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint48
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint56
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint64
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint72
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint80
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint88
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint96
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint104
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint112
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint120
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint128
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint136
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint144
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint152
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint160
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint168
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint176
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint184
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint192
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint200
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint208
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint216
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint224
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint232
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint240
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint248
) -> (res : Int152):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(152, rhs.value)
    if large_shift == 1:
        return (Int152(0))
    else:
        let preserved_width = 152 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int152(value=res))
    end
end
func warp_shl_signed152_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int152, rhs : Uint256
) -> (res : Int152):
    if rhs.high == 0:
        let (res) = warp_shl_signed152_152(lhs, Uint152(rhs.low))
        return (res)
    else:
        return (Int152(value=0))
    end
end
func warp_shl_signed160_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint8
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint16
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint24
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint32
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint40
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint48
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint56
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint64
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint72
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint80
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint88
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint96
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint104
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint112
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint120
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint128
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint136
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint144
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint152
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint160
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint168
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint176
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint184
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint192
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint200
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint208
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint216
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint224
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint232
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint240
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint248
) -> (res : Int160):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(160, rhs.value)
    if large_shift == 1:
        return (Int160(0))
    else:
        let preserved_width = 160 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int160(value=res))
    end
end
func warp_shl_signed160_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int160, rhs : Uint256
) -> (res : Int160):
    if rhs.high == 0:
        let (res) = warp_shl_signed160_160(lhs, Uint160(rhs.low))
        return (res)
    else:
        return (Int160(value=0))
    end
end
func warp_shl_signed168_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint8
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint16
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint24
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint32
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint40
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint48
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint56
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint64
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint72
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint80
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint88
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint96
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint104
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint112
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint120
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint128
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint136
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint144
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint152
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint160
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint168
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint176
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint184
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint192
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint200
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint208
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint216
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint224
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint232
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint240
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint248
) -> (res : Int168):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(168, rhs.value)
    if large_shift == 1:
        return (Int168(0))
    else:
        let preserved_width = 168 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int168(value=res))
    end
end
func warp_shl_signed168_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int168, rhs : Uint256
) -> (res : Int168):
    if rhs.high == 0:
        let (res) = warp_shl_signed168_168(lhs, Uint168(rhs.low))
        return (res)
    else:
        return (Int168(value=0))
    end
end
func warp_shl_signed176_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint8
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint16
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint24
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint32
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint40
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint48
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint56
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint64
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint72
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint80
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint88
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint96
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint104
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint112
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint120
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint128
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint136
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint144
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint152
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint160
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint168
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint176
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint184
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint192
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint200
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint208
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint216
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint224
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint232
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint240
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint248
) -> (res : Int176):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(176, rhs.value)
    if large_shift == 1:
        return (Int176(0))
    else:
        let preserved_width = 176 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int176(value=res))
    end
end
func warp_shl_signed176_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int176, rhs : Uint256
) -> (res : Int176):
    if rhs.high == 0:
        let (res) = warp_shl_signed176_176(lhs, Uint176(rhs.low))
        return (res)
    else:
        return (Int176(value=0))
    end
end
func warp_shl_signed184_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint8
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint16
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint24
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint32
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint40
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint48
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint56
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint64
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint72
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint80
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint88
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint96
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint104
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint112
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint120
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint128
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint136
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint144
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint152
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint160
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint168
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint176
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint184
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint192
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint200
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint208
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint216
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint224
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint232
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint240
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint248
) -> (res : Int184):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(184, rhs.value)
    if large_shift == 1:
        return (Int184(0))
    else:
        let preserved_width = 184 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int184(value=res))
    end
end
func warp_shl_signed184_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int184, rhs : Uint256
) -> (res : Int184):
    if rhs.high == 0:
        let (res) = warp_shl_signed184_184(lhs, Uint184(rhs.low))
        return (res)
    else:
        return (Int184(value=0))
    end
end
func warp_shl_signed192_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint8
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint16
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint24
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint32
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint40
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint48
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint56
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint64
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint72
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint80
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint88
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint96
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint104
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint112
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint120
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint128
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint136
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint144
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint152
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint160
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint168
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint176
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint184
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint192
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint200
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint208
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint216
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint224
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint232
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint240
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint248
) -> (res : Int192):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(192, rhs.value)
    if large_shift == 1:
        return (Int192(0))
    else:
        let preserved_width = 192 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int192(value=res))
    end
end
func warp_shl_signed192_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int192, rhs : Uint256
) -> (res : Int192):
    if rhs.high == 0:
        let (res) = warp_shl_signed192_192(lhs, Uint192(rhs.low))
        return (res)
    else:
        return (Int192(value=0))
    end
end
func warp_shl_signed200_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint8
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint16
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint24
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint32
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint40
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint48
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint56
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint64
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint72
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint80
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint88
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint96
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint104
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint112
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint120
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint128
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint136
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint144
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint152
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint160
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint168
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint176
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint184
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint192
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint200
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint208
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint216
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint224
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint232
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint240
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint248
) -> (res : Int200):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(200, rhs.value)
    if large_shift == 1:
        return (Int200(0))
    else:
        let preserved_width = 200 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int200(value=res))
    end
end
func warp_shl_signed200_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int200, rhs : Uint256
) -> (res : Int200):
    if rhs.high == 0:
        let (res) = warp_shl_signed200_200(lhs, Uint200(rhs.low))
        return (res)
    else:
        return (Int200(value=0))
    end
end
func warp_shl_signed208_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint8
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint16
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint24
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint32
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint40
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint48
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint56
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint64
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint72
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint80
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint88
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint96
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint104
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint112
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint120
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint128
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint136
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint144
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint152
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint160
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint168
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint176
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint184
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint192
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint200
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint208
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint216
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint224
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint232
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint240
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint248
) -> (res : Int208):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(208, rhs.value)
    if large_shift == 1:
        return (Int208(0))
    else:
        let preserved_width = 208 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int208(value=res))
    end
end
func warp_shl_signed208_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int208, rhs : Uint256
) -> (res : Int208):
    if rhs.high == 0:
        let (res) = warp_shl_signed208_208(lhs, Uint208(rhs.low))
        return (res)
    else:
        return (Int208(value=0))
    end
end
func warp_shl_signed216_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint8
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint16
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint24
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint32
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint40
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint48
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint56
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint64
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint72
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint80
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint88
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint96
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint104
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint112
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint120
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint128
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint136
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint144
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint152
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint160
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint168
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint176
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint184
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint192
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint200
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint208
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint216
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint224
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint232
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint240
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint248
) -> (res : Int216):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(216, rhs.value)
    if large_shift == 1:
        return (Int216(0))
    else:
        let preserved_width = 216 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int216(value=res))
    end
end
func warp_shl_signed216_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int216, rhs : Uint256
) -> (res : Int216):
    if rhs.high == 0:
        let (res) = warp_shl_signed216_216(lhs, Uint216(rhs.low))
        return (res)
    else:
        return (Int216(value=0))
    end
end
func warp_shl_signed224_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint8
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint16
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint24
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint32
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint40
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint48
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint56
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint64
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint72
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint80
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint88
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint96
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint104
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint112
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint120
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint128
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint136
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint144
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint152
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint160
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint168
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint176
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint184
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint192
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint200
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint208
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint216
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint224
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint232
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint240
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint248
) -> (res : Int224):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(224, rhs.value)
    if large_shift == 1:
        return (Int224(0))
    else:
        let preserved_width = 224 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int224(value=res))
    end
end
func warp_shl_signed224_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int224, rhs : Uint256
) -> (res : Int224):
    if rhs.high == 0:
        let (res) = warp_shl_signed224_224(lhs, Uint224(rhs.low))
        return (res)
    else:
        return (Int224(value=0))
    end
end
func warp_shl_signed232_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint8
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint16
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint24
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint32
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint40
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint48
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint56
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint64
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint72
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint80
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint88
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint96
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint104
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint112
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint120
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint128
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint136
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint144
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint152
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint160
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint168
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint176
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint184
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint192
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint200
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint208
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint216
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint224
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint232
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint240
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint248
) -> (res : Int232):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(232, rhs.value)
    if large_shift == 1:
        return (Int232(0))
    else:
        let preserved_width = 232 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int232(value=res))
    end
end
func warp_shl_signed232_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int232, rhs : Uint256
) -> (res : Int232):
    if rhs.high == 0:
        let (res) = warp_shl_signed232_232(lhs, Uint232(rhs.low))
        return (res)
    else:
        return (Int232(value=0))
    end
end
func warp_shl_signed240_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint8
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint16
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint24
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint32
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint40
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint48
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint56
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint64
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint72
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint80
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint88
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint96
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint104
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint112
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint120
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint128
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint136
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint144
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint152
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint160
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint168
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint176
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint184
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint192
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint200
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint208
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint216
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint224
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint232
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint240
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint248
) -> (res : Int240):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(240, rhs.value)
    if large_shift == 1:
        return (Int240(0))
    else:
        let preserved_width = 240 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int240(value=res))
    end
end
func warp_shl_signed240_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int240, rhs : Uint256
) -> (res : Int240):
    if rhs.high == 0:
        let (res) = warp_shl_signed240_240(lhs, Uint240(rhs.low))
        return (res)
    else:
        return (Int240(value=0))
    end
end
func warp_shl_signed248_8{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint8
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_16{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint16
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_24{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint24
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_32{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint32
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_40{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint40
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_48{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint48
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_56{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint56
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_64{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint64
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_72{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint72
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_80{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint80
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_88{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint88
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_96{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint96
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_104{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint104
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_112{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint112
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_120{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint120
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_128{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint128
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_136{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint136
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_144{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint144
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_152{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint152
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint160
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_168{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint168
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_176{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint176
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_184{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint184
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_192{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint192
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_200{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint200
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_208{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint208
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_216{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint216
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_224{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint224
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_232{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint232
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_240{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint240
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_248{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint248
) -> (res : Int248):
    # width <= rhs (shift amount) means result will be 0
    let (large_shift) = is_le_felt(248, rhs.value)
    if large_shift == 1:
        return (Int248(0))
    else:
        let preserved_width = 248 - rhs.value
        let (preserved_bound) = pow2(preserved_width)
        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)
        let (multiplier) = pow2(rhs.value)
        let res = lhs_truncated * multiplier
        return (Int248(value=res))
    end
end
func warp_shl_signed248_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Int248, rhs : Uint256
) -> (res : Int248):
    if rhs.high == 0:
        let (res) = warp_shl_signed248_248(lhs, Uint248(rhs.low))
        return (res)
    else:
        return (Int248(value=0))
    end
end
func warp_shl_signed256_8{range_check_ptr}(lhs : Int256, rhs : Uint8) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_16{range_check_ptr}(lhs : Int256, rhs : Uint16) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_24{range_check_ptr}(lhs : Int256, rhs : Uint24) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_32{range_check_ptr}(lhs : Int256, rhs : Uint32) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_40{range_check_ptr}(lhs : Int256, rhs : Uint40) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_48{range_check_ptr}(lhs : Int256, rhs : Uint48) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_56{range_check_ptr}(lhs : Int256, rhs : Uint56) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_64{range_check_ptr}(lhs : Int256, rhs : Uint64) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_72{range_check_ptr}(lhs : Int256, rhs : Uint72) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_80{range_check_ptr}(lhs : Int256, rhs : Uint80) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_88{range_check_ptr}(lhs : Int256, rhs : Uint88) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_96{range_check_ptr}(lhs : Int256, rhs : Uint96) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_104{range_check_ptr}(lhs : Int256, rhs : Uint104) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_112{range_check_ptr}(lhs : Int256, rhs : Uint112) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_120{range_check_ptr}(lhs : Int256, rhs : Uint120) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_128{range_check_ptr}(lhs : Int256, rhs : Uint128) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_136{range_check_ptr}(lhs : Int256, rhs : Uint136) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_144{range_check_ptr}(lhs : Int256, rhs : Uint144) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_152{range_check_ptr}(lhs : Int256, rhs : Uint152) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_160{range_check_ptr}(lhs : Int256, rhs : Uint160) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_168{range_check_ptr}(lhs : Int256, rhs : Uint168) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_176{range_check_ptr}(lhs : Int256, rhs : Uint176) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_184{range_check_ptr}(lhs : Int256, rhs : Uint184) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_192{range_check_ptr}(lhs : Int256, rhs : Uint192) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_200{range_check_ptr}(lhs : Int256, rhs : Uint200) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_208{range_check_ptr}(lhs : Int256, rhs : Uint208) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_216{range_check_ptr}(lhs : Int256, rhs : Uint216) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_224{range_check_ptr}(lhs : Int256, rhs : Uint224) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_232{range_check_ptr}(lhs : Int256, rhs : Uint232) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_240{range_check_ptr}(lhs : Int256, rhs : Uint240) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_248{range_check_ptr}(lhs : Int256, rhs : Uint248) -> (result : Int256):
    let (high, low) = split_felt(rhs.value)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
func warp_shl_signed256_256{range_check_ptr}(lhs : Int256, rhs : Uint256) -> (result : Int256):
    let (res) = uint256_shl(lhs.value, rhs)
    return (Int256(value=res))
end
func warp_shl_signed256{range_check_ptr}(lhs : Int256, rhs : felt) -> (result : Int256):
    let (high, low) = split_felt(rhs)
    let (res) = uint256_shl(lhs.value, Uint256(low, high))
    return (Int256(value=res))
end
