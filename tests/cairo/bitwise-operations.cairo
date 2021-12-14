%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_or, uint256_not, uint256_xor)

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals

    let a : Uint256 = Uint256(13, 0)
    let b : Uint256 = Uint256(3, 0)

    let (local res1) = uint256_and(a, b)
    let (local res2) = uint256_or(a, b)
    let (local res3) = uint256_not(b)
    let (local res4) = uint256_xor(a, b)

    serialize_word(res1.low)
    serialize_word(res1.high)
    serialize_word(res2.low)
    serialize_word(res2.high)
    serialize_word(res3.low)
    serialize_word(res3.high)
    serialize_word(res4.low)
    serialize_word(res4.high)

    return ()
end
