# AUTO-GENERATED
from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem
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
from warplib.maths.int_conversions import (
    warp_uint8_to_uint256,
    warp_uint16_to_uint256,
    warp_uint24_to_uint256,
    warp_uint32_to_uint256,
    warp_uint40_to_uint256,
    warp_uint48_to_uint256,
    warp_uint56_to_uint256,
    warp_uint64_to_uint256,
    warp_uint72_to_uint256,
    warp_uint80_to_uint256,
    warp_uint88_to_uint256,
    warp_uint96_to_uint256,
    warp_uint104_to_uint256,
    warp_uint112_to_uint256,
    warp_uint120_to_uint256,
    warp_uint128_to_uint256,
    warp_uint136_to_uint256,
    warp_uint144_to_uint256,
    warp_uint152_to_uint256,
    warp_uint160_to_uint256,
    warp_uint168_to_uint256,
    warp_uint176_to_uint256,
    warp_uint184_to_uint256,
    warp_uint192_to_uint256,
    warp_uint200_to_uint256,
    warp_uint208_to_uint256,
    warp_uint216_to_uint256,
    warp_uint224_to_uint256,
    warp_uint232_to_uint256,
    warp_uint240_to_uint256,
    warp_uint248_to_uint256,
)

const SHIFT = 2 ** 128

func warp_mod8{range_check_ptr}(lhs : Uint8, rhs : Uint8) -> (res : Uint8):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint8_to_uint256(lhs)
    let (rhs_256) = warp_uint8_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint8(value=res_felt))
end
func warp_mod16{range_check_ptr}(lhs : Uint16, rhs : Uint16) -> (res : Uint16):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint16_to_uint256(lhs)
    let (rhs_256) = warp_uint16_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint16(value=res_felt))
end
func warp_mod24{range_check_ptr}(lhs : Uint24, rhs : Uint24) -> (res : Uint24):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint24_to_uint256(lhs)
    let (rhs_256) = warp_uint24_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint24(value=res_felt))
end
func warp_mod32{range_check_ptr}(lhs : Uint32, rhs : Uint32) -> (res : Uint32):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint32_to_uint256(lhs)
    let (rhs_256) = warp_uint32_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint32(value=res_felt))
end
func warp_mod40{range_check_ptr}(lhs : Uint40, rhs : Uint40) -> (res : Uint40):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint40_to_uint256(lhs)
    let (rhs_256) = warp_uint40_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint40(value=res_felt))
end
func warp_mod48{range_check_ptr}(lhs : Uint48, rhs : Uint48) -> (res : Uint48):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint48_to_uint256(lhs)
    let (rhs_256) = warp_uint48_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint48(value=res_felt))
end
func warp_mod56{range_check_ptr}(lhs : Uint56, rhs : Uint56) -> (res : Uint56):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint56_to_uint256(lhs)
    let (rhs_256) = warp_uint56_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint56(value=res_felt))
end
func warp_mod64{range_check_ptr}(lhs : Uint64, rhs : Uint64) -> (res : Uint64):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint64_to_uint256(lhs)
    let (rhs_256) = warp_uint64_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint64(value=res_felt))
end
func warp_mod72{range_check_ptr}(lhs : Uint72, rhs : Uint72) -> (res : Uint72):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint72_to_uint256(lhs)
    let (rhs_256) = warp_uint72_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint72(value=res_felt))
end
func warp_mod80{range_check_ptr}(lhs : Uint80, rhs : Uint80) -> (res : Uint80):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint80_to_uint256(lhs)
    let (rhs_256) = warp_uint80_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint80(value=res_felt))
end
func warp_mod88{range_check_ptr}(lhs : Uint88, rhs : Uint88) -> (res : Uint88):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint88_to_uint256(lhs)
    let (rhs_256) = warp_uint88_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint88(value=res_felt))
end
func warp_mod96{range_check_ptr}(lhs : Uint96, rhs : Uint96) -> (res : Uint96):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint96_to_uint256(lhs)
    let (rhs_256) = warp_uint96_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint96(value=res_felt))
end
func warp_mod104{range_check_ptr}(lhs : Uint104, rhs : Uint104) -> (res : Uint104):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint104_to_uint256(lhs)
    let (rhs_256) = warp_uint104_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint104(value=res_felt))
end
func warp_mod112{range_check_ptr}(lhs : Uint112, rhs : Uint112) -> (res : Uint112):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint112_to_uint256(lhs)
    let (rhs_256) = warp_uint112_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint112(value=res_felt))
end
func warp_mod120{range_check_ptr}(lhs : Uint120, rhs : Uint120) -> (res : Uint120):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint120_to_uint256(lhs)
    let (rhs_256) = warp_uint120_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint120(value=res_felt))
end
func warp_mod128{range_check_ptr}(lhs : Uint128, rhs : Uint128) -> (res : Uint128):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint128_to_uint256(lhs)
    let (rhs_256) = warp_uint128_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint128(value=res_felt))
end
func warp_mod136{range_check_ptr}(lhs : Uint136, rhs : Uint136) -> (res : Uint136):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint136_to_uint256(lhs)
    let (rhs_256) = warp_uint136_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint136(value=res_felt))
end
func warp_mod144{range_check_ptr}(lhs : Uint144, rhs : Uint144) -> (res : Uint144):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint144_to_uint256(lhs)
    let (rhs_256) = warp_uint144_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint144(value=res_felt))
end
func warp_mod152{range_check_ptr}(lhs : Uint152, rhs : Uint152) -> (res : Uint152):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint152_to_uint256(lhs)
    let (rhs_256) = warp_uint152_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint152(value=res_felt))
end
func warp_mod160{range_check_ptr}(lhs : Uint160, rhs : Uint160) -> (res : Uint160):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint160_to_uint256(lhs)
    let (rhs_256) = warp_uint160_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint160(value=res_felt))
end
func warp_mod168{range_check_ptr}(lhs : Uint168, rhs : Uint168) -> (res : Uint168):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint168_to_uint256(lhs)
    let (rhs_256) = warp_uint168_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint168(value=res_felt))
end
func warp_mod176{range_check_ptr}(lhs : Uint176, rhs : Uint176) -> (res : Uint176):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint176_to_uint256(lhs)
    let (rhs_256) = warp_uint176_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint176(value=res_felt))
end
func warp_mod184{range_check_ptr}(lhs : Uint184, rhs : Uint184) -> (res : Uint184):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint184_to_uint256(lhs)
    let (rhs_256) = warp_uint184_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint184(value=res_felt))
end
func warp_mod192{range_check_ptr}(lhs : Uint192, rhs : Uint192) -> (res : Uint192):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint192_to_uint256(lhs)
    let (rhs_256) = warp_uint192_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint192(value=res_felt))
end
func warp_mod200{range_check_ptr}(lhs : Uint200, rhs : Uint200) -> (res : Uint200):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint200_to_uint256(lhs)
    let (rhs_256) = warp_uint200_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint200(value=res_felt))
end
func warp_mod208{range_check_ptr}(lhs : Uint208, rhs : Uint208) -> (res : Uint208):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint208_to_uint256(lhs)
    let (rhs_256) = warp_uint208_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint208(value=res_felt))
end
func warp_mod216{range_check_ptr}(lhs : Uint216, rhs : Uint216) -> (res : Uint216):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint216_to_uint256(lhs)
    let (rhs_256) = warp_uint216_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint216(value=res_felt))
end
func warp_mod224{range_check_ptr}(lhs : Uint224, rhs : Uint224) -> (res : Uint224):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint224_to_uint256(lhs)
    let (rhs_256) = warp_uint224_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint224(value=res_felt))
end
func warp_mod232{range_check_ptr}(lhs : Uint232, rhs : Uint232) -> (res : Uint232):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint232_to_uint256(lhs)
    let (rhs_256) = warp_uint232_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint232(value=res_felt))
end
func warp_mod240{range_check_ptr}(lhs : Uint240, rhs : Uint240) -> (res : Uint240):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint240_to_uint256(lhs)
    let (rhs_256) = warp_uint240_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint240(value=res_felt))
end
func warp_mod248{range_check_ptr}(lhs : Uint248, rhs : Uint248) -> (res : Uint248):
    if rhs.value == 0:
        with_attr error_message("Modulo by zero error"):
            assert 1 = 0
        end
    end
    let (lhs_256) = warp_uint248_to_uint256(lhs)
    let (rhs_256) = warp_uint248_to_uint256(rhs)
    let (_, res256) = uint256_unsigned_div_rem(lhs_256, rhs_256)
    let res_felt = res256.low + SHIFT * res256.high
    return (Uint248(value=res_felt))
end
func warp_mod256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):
    if rhs.high == 0:
        if rhs.low == 0:
            with_attr error_message("Modulo by zero error"):
                assert 1 = 0
            end
        end
    end
    let (_, res : Uint256) = uint256_unsigned_div_rem(lhs, rhs)
    return (res)
end
