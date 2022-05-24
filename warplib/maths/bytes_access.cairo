from warplib.maths.pow2 import pow2
from starkware.cairo.common.bitwise import bitwise_and
from warplib.maths.utils import narrow_safe

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

func byte_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : felt, index : Uint256
) -> (res : felt):
    let (index_felt) = narrow_safe(index)
    let index_felt8 = index_felt * 8
    let (offset) = pow2(index_felt8)
    let (res_and) = bitwise_and(base, offset)
    let res = res_and / offset
    return (res)
end

func byte_at_index{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(base : felt, index : felt) -> (
    res : felt
):
    let index_felt8 = index * 8
    let (offset) = pow2(index_felt8)
    let (res_and) = bitwise_and(base, offset)
    let res = res_and / offset
    return (res)
end

func byte256_at_index{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(base : Uint256, index : felt) -> (
    res : felt
):
    let index_felt8 = index * 8
    let (base_felt) = narrow_safe(base)
    let (offset) = pow2(index_felt8)
    let (res_and) = bitwise_and(base_felt, offset)
    let res = res_and / offset
    return (res)
end

func byte256_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(base : Uint256, index : Uint256) -> (
    res : felt
):
    alloc_locals
    let (index_felt) = narrow_safe(index)
    let index_felt8 = index_felt * 8
    let (base_felt) = narrow_safe(base)
    let (offset) = pow2(index_felt8)
    let (res_and) = bitwise_and(base_felt, offset)
    let res = res_and / offset
    return (res)
end