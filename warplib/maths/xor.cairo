from starkware.cairo.common.bitwise import bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_xor

func warp_xor{bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt):
    return bitwise_xor(lhs, rhs)
end

func warp_xor256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (
    res : Uint256
):
    return uint256_xor(lhs, rhs)
end
