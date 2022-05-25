from warplib.maths.pow2 import pow2
from starkware.cairo.common.bitwise import bitwise_and
from warplib.maths.utils import narrow_safe

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import assert_le_felt
from starkware.cairo.common.math_cmp import is_le_felt

from starkware.cairo.common.serialize import serialize_word

func byte_accessor{range_check_ptr}(index : felt) -> (offset : felt):
    assert_le_felt(index, 31)
    let (pow2index) = pow2(index * 8)
    if index == 31:
        return (7 * pow2index)
    end
    return (255 * pow2index)
end

func byte_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : felt, index : Uint256, width : felt
) -> (res : felt):
    alloc_locals

    let (max_range_plus1) = pow2(width * 8)
    assert_le_felt(base, max_range_plus1 - 1)

    let (index_felt) = narrow_safe(index)
    let (byte_accesor_felt) = byte_accessor(index_felt)
    let (slicer) = pow2(index_felt * 8)
    let (res_and) = bitwise_and(base, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end

func byte_at_index{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : felt, index : felt, width : felt
) -> (res : felt):
    alloc_locals

    let (max_range_plus1) = pow2(width * 8)
    assert_le_felt(base, max_range_plus1 - 1)

    let (byte_accesor_felt) = byte_accessor(index)
    let (slicer) = pow2(index * 8)
    let (res_and) = bitwise_and(base, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end

func byte256_at_index{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : Uint256, index : felt, width : felt
) -> (res : felt):
    alloc_locals

    let (inRangeHigh : felt) = is_le_felt(base.high, 0xffffffffffffffffffffffffffffffff)
    let (inRangeLow : felt) = is_le_felt(base.low, 0xffffffffffffffffffffffffffffffff)
    assert inRangeHigh * inRangeLow = 1

    let (base_felt) = narrow_safe(base)
    let (byte_accesor_felt) = byte_accessor(index)
    let (slicer) = pow2(index * 8)
    let (res_and) = bitwise_and(base_felt, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end

func byte256_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : Uint256, index : Uint256, width : felt
) -> (res : felt):
    alloc_locals

    let (inRangeHigh : felt) = is_le_felt(base.high, 0xffffffffffffffffffffffffffffffff)
    let (inRangeLow : felt) = is_le_felt(base.low, 0xffffffffffffffffffffffffffffffff)
    assert inRangeHigh * inRangeLow = 1

    let (index_felt) = narrow_safe(index)
    let (base_felt) = narrow_safe(base)
    let (byte_accesor_felt) = byte_accessor(index_felt)
    let (slicer) = pow2(index_felt * 8)
    let (res_and) = bitwise_and(base_felt, byte_accesor_felt)
    let res = res_and / slicer
    return (res)
end
