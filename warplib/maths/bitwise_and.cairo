from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_and

func warp_bitwise_and{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt):
    return bitwise_and(lhs, rhs)
end

func warp_bitwise_and256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    lhs : Uint256, rhs : Uint256
) -> (res : Uint256):
    return uint256_and(lhs, rhs)
end
