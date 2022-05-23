from warplib.maths.pow2 import pow2
from warplib.maths.div import warp_div
from warplib.maths.bitwise_and import warp_bitwise_and
from warplib.maths.utils import uint256_to_address_felt

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256


func byte_at_index{ bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(base : felt, index : Uint256 ) -> (res : felt):
    alloc_locals
    let (index_felt) = uint256_to_address_felt(index)
    let index_felt8 = index_felt * 8
    let (offset) = pow2(index_felt8)
    let (res_and) = warp_bitwise_and(base, offset)
    local bitwise_ptr :  BitwiseBuiltin* = bitwise_ptr
    let (res) = warp_div(res_and, offset)
    return (res)
end