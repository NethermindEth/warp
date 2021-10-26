%builtins output range_check bitwise
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_or

from starkware.cairo.common.pow import pow
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_sub)

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let (local shift_mul: felt) = pow(2,128)
    tempvar addr : Uint256 = Uint256(low=77848437765567505034689872680670456007, high=7895204607547027278746525876888984095)
    tempvar addr_low = addr.low
    local big_part : felt = addr.high * shift_mul
    let (local res : felt) = bitwise_or(big_part, addr.low)
    assert res = 0x05f08fa40ece3c8a9b241484c812da1f3a9110515f6261c259309cdccb83e8c7
    return ()
end

