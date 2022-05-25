from warplib.maths.pow2 import pow2
from starkware.cairo.common.bitwise import bitwise_and

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import assert_le_felt, assert_nn_le
from starkware.cairo.common.math_cmp import is_le_felt, is_nn_le

from starkware.cairo.common.serialize import serialize_word

func byte_accessor{range_check_ptr}(index : felt) -> (offset : felt):
    let (pow2index) = pow2(index * 8)
    return (255 * pow2index)
end

func byte_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : felt, index : Uint256, width : felt
) -> (res : felt):
    alloc_locals

    assert index.high = 0
    assert_nn_le(index.low, width - 1)

    let index_felt = index.low
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

    assert_nn_le(index, width - 1)

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
    assert_nn_le(index, 31)

    let (less_than_eq_15) = is_le_felt(index, 15)
    if less_than_eq_15 == 1:
        let (byte_accesor_felt) = byte_accessor(index)
        let (slicer) = pow2(index * 8)
        let (res_and) = bitwise_and(base.low, byte_accesor_felt)
        let res = res_and / slicer
        return (res)
    else:
        let index_adjusted = index - 16
        let (byte_accesor_felt) = byte_accessor(index_adjusted)
        let (slicer) = pow2(index_adjusted * 8)
        let (res_and) = bitwise_and(base.high, byte_accesor_felt)
        let res = res_and / slicer
        return (res)
    end
end

func byte256_at_index_uint256{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    base : Uint256, index : Uint256, width : felt
) -> (res : felt):
    alloc_locals

    assert index.high = 0
    assert_nn_le(index.low, 31)

    let (less_than_eq_15) = is_le_felt(index.low, 15)
    if less_than_eq_15 == 1:
        let (byte_accesor_felt) = byte_accessor(index.low)
        let (slicer) = pow2(index.low * 8)
        let (res_and) = bitwise_and(base.low, byte_accesor_felt)
        let res = res_and / slicer
        return (res)
    else:
        let index_adjusted = index.low - 16
        let (byte_accesor_felt) = byte_accessor(index_adjusted)
        let (slicer) = pow2(index_adjusted * 8)
        let (res_and) = bitwise_and(base.high, byte_accesor_felt)
        let res = res_and / slicer
        return (res)
    end
end
