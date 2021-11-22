from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict import DictAccess, dict_read
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256

from evm.bit_packing import exp_byte, extract_unaligned_uint128, replace_lower_bytes, split_on_byte
from evm.memory import mstore

func array_create_from_memory{memory_dict : DictAccess*, range_check_ptr}(offset, length) -> (
        array : felt*):
    # Create a 128-bit packed big-endian array that contains memory
    # contents from offset to offset + length
    alloc_locals
    let (array) = alloc()
    array_copy_from_memory(offset=offset, length=length, array=array)
    return (array)
end

func array_copy_from_memory{memory_dict : DictAccess*, range_check_ptr}(
        offset, length, array : felt*):
    # Copies memory contents from 'offset' to 'offset + length' to
    # 'array'. See 'array_create_from_memory'.
    alloc_locals
    if length == 0:
        return ()
    end

    let (div, rem) = unsigned_div_rem(offset, 16)
    if rem == 0:
        # aligned
        return copy_from_memory_aligned(offset, length, array)
    end

    let (block) = dict_read{dict_ptr=memory_dict}(div * 16)
    let shift = 16 - rem
    let (remains, _) = split_on_byte(block, byte_pos=shift)
    return copy_from_memory_shifted(
        shift=shift, aligned_offset=offset + shift, remains=remains, length=length, array=array)
end

func copy_from_memory_aligned{memory_dict : DictAccess*, range_check_ptr}(
        aligned_offset, length, array : felt*):
    alloc_locals
    let (block) = dict_read{dict_ptr=memory_dict}(aligned_offset)
    let (le) = is_le(length, 16)
    if le == 1:
        let (block) = replace_lower_bytes(block, 0, n=16 - length)
        array[0] = block
        return ()
    end
    array[0] = block
    return copy_from_memory_aligned(aligned_offset + 16, length - 16, array + 1)
end

func copy_from_memory_shifted{memory_dict : DictAccess*, range_check_ptr}(
        shift, aligned_offset, remains, length, array : felt*):
    alloc_locals
    let (exp) = exp_byte(shift)
    let (remains_enough) = is_le(shift, length)
    if remains_enough == 1:
        let (block) = replace_lower_bytes(remains * exp, 0, n=16 - length)
        array[0] = block
        return ()
    end
    let (block) = dict_read{dict_ptr=memory_dict}(aligned_offset)
    let (new_remains, completion) = split_on_byte(block, byte_pos=shift)
    assert array[0] = completion + remains * exp
    return copy_from_memory_shifted(
        shift=shift,
        aligned_offset=aligned_offset + 16,
        remains=new_remains,
        length=length - 16,
        array=array + 1)
end

func array_copy_to_memory{memory_dict : DictAccess*, range_check_ptr}(
        array_length, array : felt*, array_offset, memory_offset, length):
    # Given a 128-bit packed 'array' with a total of 'array_length'
    # bytes, copy from the array 'length' bytes starting with
    # 'array_offset' into memory starting with 'memory_offset'.
    alloc_locals
    let (block) = array_load(array_length, array, array_offset)
    let (le_32) = is_le(length, 32)
    if le_32 == 1:
        let (le_16) = is_le(length, 16)
        if le_16 == 1:
            let (_high) = replace_lower_bytes(block.high, 0, n=16 - length)
            mstore(memory_offset, Uint256(low=0, high=_high))
        else:
            let (_low) = replace_lower_bytes(block.low, 0, n=32 - length)
            mstore(memory_offset, Uint256(low=_low, high=block.high))
        end
        return ()
    end
    mstore(memory_offset, block)
    return array_copy_to_memory(
        array_length, array, array_offset + 32, memory_offset + 32, length - 32)
end

func array_load{range_check_ptr}(array_length : felt, array : felt*, offset) -> (value : Uint256):
    # Load a value from a 128-bit packed big-endian
    # array.
    #
    # 'array_length' is the length of the array in bytes.
    # 'offset' is the byte to start reading from.
    alloc_locals
    let (index, rem) = unsigned_div_rem(offset, 16)
    let (high) = safe_read(array_length, array, index)
    let (mid) = safe_read(array_length, array, index + 1)
    if rem == 0:
        return (Uint256(low=mid, high=high))
    end
    let (low) = safe_read(array_length, array, index + 2)
    let (unaligned_low) = extract_unaligned_uint128(shift=rem, low=low, high=mid)
    let (unaligned_high) = extract_unaligned_uint128(shift=rem, low=mid, high=high)
    return (Uint256(low=unaligned_low, high=unaligned_high))
end

func safe_read{range_check_ptr}(array_length, array : felt*, index) -> (value):
    let (le) = is_le(array_length, index * 16)  # array_length is measured in bytes, 16 in a cell
    if le == 1:
        return (0)
    else:
        return (array[index])
    end
end

func validate_array{range_check_ptr}(array_len, array : felt*):
    # Verifies that all felts in the 'array' of length 'array_len' are
    # in the range [0, 2^128).
    if array_len == 0:
        return ()
    end
    assert [range_check_ptr] = array[0]
    let range_check_ptr = range_check_ptr + 1
    return validate_array(array_len - 1, array + 1)
end
