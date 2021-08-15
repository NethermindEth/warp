from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256

from evm.bit_packing import replace_lower_bytes, read_uint128 as general_read_uint128
from evm.memory import (
    read_uint128 as memory_read_uint128,
    write_uint128 as memory_write_uint128,
    )
from evm.utils import floor_div, ceil_div

# as a 128-bit packed big-endian array
func create_from_memory{memory_dict: DictAccess*, range_check_ptr}(
    offset, length
    ) -> (array: felt*):
    alloc_locals
    let (local array) = alloc()
    copy_from_memory(offset, length, array)
    return (array)
end

func copy_from_memory{memory_dict: DictAccess*, range_check_ptr}(
    offset, length, array: felt*
    ):
    alloc_locals
    if length == 0:
        return ()
    end

    let (local block) = memory_read_uint128(offset)
    local memory_dict: DictAccess* = memory_dict
    let (finish) = is_le(length, 15)
    if finish == 1:
        let (block) = replace_lower_bytes(block, 0, 16 - length)
        assert array[0] = block
        return ()
    end

    assert array[0] = block
    return copy_from_memory(offset + 16, length - 16, array + 1)
end

func copy_to_memory{memory_dict: DictAccess*, range_check_ptr}(
    array_length, array: felt*, array_offset,
    memory_offset, length,
    ):
    alloc_locals
    let (local value) = read_uint128(array_length, array, array_offset)
    let (local res) = is_le(length, 16)
    if res == 1:
        let (value) = replace_lower_bytes(value, 0, 16 - length)
        memory_write_uin128(memory_offset, value)
        return ()
    else:
        memory_write_uin128(memory_offset, value)
        return copy_to_memory(array_length, array,
            array_offset + 16, memory_offset + 16, length - 16)
    end
end

func aload{range_check_ptr}(array_length : felt, array: felt*, offset)
    -> (value: Uint256):
    alloc_locals
    let (local high) = read_uint128(array_length, array, offset)
    let (low) = read_uint128(array_length, array, offset + 16)
    return (Uint256(low, high))
end

func read_uint128{range_check_ptr}(array_length, array: felt*, offset)
     -> (value):
    alloc_locals
    let (lower) = floor_div(offset, 16)
    let (local higher) = ceil_div(offset, 16)
    let (local lower_v) = safe_read(array_length, array, lower)
    let (higher_v) = safe_read(array_length, array, higher)
    return general_read_uint128(offset, lower_v, higher_v)
end

func safe_read{range_check_ptr}(array_length, array: felt*, index) -> (value):
    is_le(array_length, index * 16)  # array_length is measured in bytes, 16 in a cell
    if [ap - 1] == 1:
        return (0)
    else:
        return (array[index])
    end
end
