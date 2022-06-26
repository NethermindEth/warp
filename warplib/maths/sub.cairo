# AUTO-GENERATED
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_le
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

func warp_sub8{range_check_ptr}(lhs : Uint8, rhs : Uint8) -> (res : Uint8):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint8(value=(lhs.value - rhs.value)))
end
func warp_sub16{range_check_ptr}(lhs : Uint16, rhs : Uint16) -> (res : Uint16):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint16(value=(lhs.value - rhs.value)))
end
func warp_sub24{range_check_ptr}(lhs : Uint24, rhs : Uint24) -> (res : Uint24):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint24(value=(lhs.value - rhs.value)))
end
func warp_sub32{range_check_ptr}(lhs : Uint32, rhs : Uint32) -> (res : Uint32):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint32(value=(lhs.value - rhs.value)))
end
func warp_sub40{range_check_ptr}(lhs : Uint40, rhs : Uint40) -> (res : Uint40):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint40(value=(lhs.value - rhs.value)))
end
func warp_sub48{range_check_ptr}(lhs : Uint48, rhs : Uint48) -> (res : Uint48):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint48(value=(lhs.value - rhs.value)))
end
func warp_sub56{range_check_ptr}(lhs : Uint56, rhs : Uint56) -> (res : Uint56):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint56(value=(lhs.value - rhs.value)))
end
func warp_sub64{range_check_ptr}(lhs : Uint64, rhs : Uint64) -> (res : Uint64):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint64(value=(lhs.value - rhs.value)))
end
func warp_sub72{range_check_ptr}(lhs : Uint72, rhs : Uint72) -> (res : Uint72):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint72(value=(lhs.value - rhs.value)))
end
func warp_sub80{range_check_ptr}(lhs : Uint80, rhs : Uint80) -> (res : Uint80):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint80(value=(lhs.value - rhs.value)))
end
func warp_sub88{range_check_ptr}(lhs : Uint88, rhs : Uint88) -> (res : Uint88):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint88(value=(lhs.value - rhs.value)))
end
func warp_sub96{range_check_ptr}(lhs : Uint96, rhs : Uint96) -> (res : Uint96):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint96(value=(lhs.value - rhs.value)))
end
func warp_sub104{range_check_ptr}(lhs : Uint104, rhs : Uint104) -> (res : Uint104):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint104(value=(lhs.value - rhs.value)))
end
func warp_sub112{range_check_ptr}(lhs : Uint112, rhs : Uint112) -> (res : Uint112):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint112(value=(lhs.value - rhs.value)))
end
func warp_sub120{range_check_ptr}(lhs : Uint120, rhs : Uint120) -> (res : Uint120):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint120(value=(lhs.value - rhs.value)))
end
func warp_sub128{range_check_ptr}(lhs : Uint128, rhs : Uint128) -> (res : Uint128):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint128(value=(lhs.value - rhs.value)))
end
func warp_sub136{range_check_ptr}(lhs : Uint136, rhs : Uint136) -> (res : Uint136):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint136(value=(lhs.value - rhs.value)))
end
func warp_sub144{range_check_ptr}(lhs : Uint144, rhs : Uint144) -> (res : Uint144):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint144(value=(lhs.value - rhs.value)))
end
func warp_sub152{range_check_ptr}(lhs : Uint152, rhs : Uint152) -> (res : Uint152):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint152(value=(lhs.value - rhs.value)))
end
func warp_sub160{range_check_ptr}(lhs : Uint160, rhs : Uint160) -> (res : Uint160):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint160(value=(lhs.value - rhs.value)))
end
func warp_sub168{range_check_ptr}(lhs : Uint168, rhs : Uint168) -> (res : Uint168):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint168(value=(lhs.value - rhs.value)))
end
func warp_sub176{range_check_ptr}(lhs : Uint176, rhs : Uint176) -> (res : Uint176):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint176(value=(lhs.value - rhs.value)))
end
func warp_sub184{range_check_ptr}(lhs : Uint184, rhs : Uint184) -> (res : Uint184):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint184(value=(lhs.value - rhs.value)))
end
func warp_sub192{range_check_ptr}(lhs : Uint192, rhs : Uint192) -> (res : Uint192):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint192(value=(lhs.value - rhs.value)))
end
func warp_sub200{range_check_ptr}(lhs : Uint200, rhs : Uint200) -> (res : Uint200):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint200(value=(lhs.value - rhs.value)))
end
func warp_sub208{range_check_ptr}(lhs : Uint208, rhs : Uint208) -> (res : Uint208):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint208(value=(lhs.value - rhs.value)))
end
func warp_sub216{range_check_ptr}(lhs : Uint216, rhs : Uint216) -> (res : Uint216):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint216(value=(lhs.value - rhs.value)))
end
func warp_sub224{range_check_ptr}(lhs : Uint224, rhs : Uint224) -> (res : Uint224):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint224(value=(lhs.value - rhs.value)))
end
func warp_sub232{range_check_ptr}(lhs : Uint232, rhs : Uint232) -> (res : Uint232):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint232(value=(lhs.value - rhs.value)))
end
func warp_sub240{range_check_ptr}(lhs : Uint240, rhs : Uint240) -> (res : Uint240):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint240(value=(lhs.value - rhs.value)))
end
func warp_sub248{range_check_ptr}(lhs : Uint248, rhs : Uint248) -> (res : Uint248):
    let (valid) = is_le_felt(rhs.value, lhs.value)
    assert valid = 1
    return (Uint248(value=(lhs.value - rhs.value)))
end
const MASK128 = 2 ** 128 - 1
const BOUND128 = 2 ** 128

func warp_sub256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (
    res : Uint256
):
    let (safe) = uint256_le(rhs, lhs)
    assert safe = 1
    # preemptively borrow from bit128
    let (low_safe) = bitwise_and(BOUND128 + lhs.low - rhs.low, MASK128)
    let low_unsafe = lhs.low - rhs.low
    if low_safe == low_unsafe:
        # the borrow was not used
        return (Uint256(low_safe, lhs.high - rhs.high))
    else:
        # the borrow was used
        return (Uint256(low_safe, lhs.high - rhs.high - 1))
    end
end
