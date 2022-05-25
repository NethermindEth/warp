from warplib.maths.pow2 import pow2
from starkware.cairo.common.bitwise import bitwise_and
from warplib.maths.utils import narrow_safe

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math_cmp import is_le

from starkware.cairo.common.serialize import serialize_word

func byte_accessor{range_check_ptr}(pos : felt) -> (offset : felt):
    let (le) = is_le(pos, 256)
    assert le = 1

    let (offset) = pow2(pos)
    let (offset1) = pow2(pos + 1)
    let (offset2) = pow2(pos + 2)

    # placing more than 3 bits will exceed the range of felt
    # and will produce overflowing results
    if pos == 31 * 8:
        return (offset + offset1 + offset2)
    end

    let (offset3) = pow2(pos + 3)
    let (offset4) = pow2(pos + 4)
    let (offset5) = pow2(pos + 5)
    let (offset6) = pow2(pos + 6)
    let (offset7) = pow2(pos + 7)
    return (offset + offset1 + offset2 + offset3 + offset4 + offset5 + offset6 + offset7)
end

func byte_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : felt, index : Uint256
) -> (res : felt):
    alloc_locals
    let (index_felt) = narrow_safe(index)
    let index_felt8 = index_felt * 8
    let (byte_accesor_felt) = byte_accessor(index_felt8)
    let (slicer) = pow2(index_felt8)
    let (res_and) = bitwise_and(base, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end

func byte_at_index{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(base : felt, index : felt) -> (
    res : felt
):
    alloc_locals
    let index_felt8 = index * 8
    let (byte_accesor_felt) = byte_accessor(index_felt8)
    let (slicer) = pow2(index_felt8)
    let (res_and) = bitwise_and(base, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end

func byte256_at_index{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : Uint256, index : felt
) -> (res : felt):
    alloc_locals
    let index_felt8 = index * 8
    let (base_felt) = narrow_safe(base)
    let (byte_accesor_felt) = byte_accessor(index_felt8)
    let (slicer) = pow2(index_felt8)
    let (res_and) = bitwise_and(base_felt, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end

func byte256_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : Uint256, index : Uint256
) -> (res : felt):
    alloc_locals
    let (index_felt) = narrow_safe(index)
    let index_felt8 = index_felt * 8
    let (base_felt) = narrow_safe(base)
    let (byte_accesor_felt) = byte_accessor(index_felt8)
    let (slicer) = pow2(index_felt8)
    let (res_and) = bitwise_and(base_felt, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end
