from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict import DictAccess
from starkware.cairo.common.math_cmp import is_le

from evm.memory import read_uint128
from evm.bit_packing import replace_lower_bytes

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

    let (local block) = read_uint128(offset)
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
