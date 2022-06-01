from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_and, bitwise_not
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.dict import DictAccess, dict_read
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256

from evm.bit_packing import exp_byte, extract_unaligned_uint128, replace_lower_bytes, split_on_byte
from evm.memory import mstore
from evm.pow2 import pow2

const UINT128_BOUND = 2 ** 128

func array_create_from_memory{
        memory_dict : DictAccess*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        offset, size) -> (array : felt*):
    # Create a 128-bit packed big-endian array that contains memory
    # contents from offset to offset + size
    alloc_locals
    let (array) = alloc()
    array_copy_from_memory(offset=offset, size=size, array=array)
    return (array)
end

func array_copy_from_memory{
        memory_dict : DictAccess*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        offset, size, array : felt*):
    # Copies memory contents from 'offset' to 'offset + size' to
    # 'array'. See 'array_create_from_memory'.
    alloc_locals
    if size == 0:
        return ()
    end

    let (div, rem) = unsigned_div_rem(offset, 16)
    if rem == 0:
        let (n, excess) = unsigned_div_rem(size, 16)
        copy_from_memory_aligned(excess, offset, n, array)
        return ()
    end

    let (block) = dict_read{dict_ptr=memory_dict}(div * 16)
    let (p) = pow2(128 - 8 * rem)
    let (_, high_part) = unsigned_div_rem(block, p)
    copy_from_memory_shifted(
        p=p, aligned_offset=offset + 16 - rem, high_part=high_part, size=size, array=array)
    return ()
end

func copy_from_memory_aligned{memory_dict : DictAccess*, bitwise_ptr : BitwiseBuiltin*}(
        excess, aligned_offset, n, array : felt*):
    alloc_locals
    let (block) = dict_read{dict_ptr=memory_dict}(aligned_offset)
    if n == 0:
        if excess == 0:
            return ()
        end
        let (p) = pow2(128 - 8 * excess)
        let (mask) = bitwise_not(p - 1)
        let (block) = bitwise_and(block, mask)
        array[0] = block
        return ()
    end
    array[0] = block
    return copy_from_memory_aligned(excess, aligned_offset + 16, n - 1, array + 1)
end

func copy_from_memory_shifted{memory_dict : DictAccess*, range_check_ptr}(
        p, aligned_offset, high_part, size, array : felt*):
    alloc_locals
    let (block) = dict_read{dict_ptr=memory_dict}(aligned_offset)
    let (low_part, new_high_part) = unsigned_div_rem(block, p)
    let value = low_part + UINT128_BOUND * high_part / p
    let (enough) = is_le(size, 16)
    if enough == 1:
        if size == 0:
            return ()
        end
        let (divisor) = pow2(128 - 8 * size)
        let (q, _) = unsigned_div_rem(value, divisor)
        assert array[0] = q * divisor
        return ()
    else:
        assert array[0] = value
        return copy_from_memory_shifted(
            p=p,
            aligned_offset=aligned_offset + 16,
            high_part=new_high_part,
            size=size - 16,
            array=array + 1)
    end
end

func array_copy_to_memory{
        memory_dict : DictAccess*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        array_len, array : felt*, array_offset, memory_offset, size):
    # Given a 128-bit packed 'array' of length 'array_len', copy from
    # the array 'size' bytes starting with 'array_offset' into memory
    # starting with 'memory_offset'.
    alloc_locals
    let (block) = array_load(array_len, array, array_offset)
    let (le_32) = is_le(size, 32)
    if le_32 == 1:
        let (le_16) = is_le(size, 16)
        if le_16 == 1:
            let (_high) = replace_lower_bytes(block.high, 0, n=16 - size)
            mstore(memory_offset, Uint256(low=0, high=_high))
        else:
            let (_low) = replace_lower_bytes(block.low, 0, n=32 - size)
            mstore(memory_offset, Uint256(low=_low, high=block.high))
        end
        return ()
    end
    mstore(memory_offset, block)
    return array_copy_to_memory(array_len, array, array_offset + 32, memory_offset + 32, size - 32)
end

func array_load{range_check_ptr}(array_len : felt, array : felt*, offset) -> (value : Uint256):
    # Load a value from a 128-bit packed big-endian
    # array.
    #
    # 'array_len' is the length of the array.
    # 'offset' is the byte to start reading from.
    alloc_locals
    let (index, rem) = unsigned_div_rem(offset, 16)
    if rem == 0:
        let (has_two) = is_le(index + 2, array_len)
        if has_two == 1:
            return (Uint256(low=array[index + 1], high=array[index]))
        end
        if index + 1 == array_len:
            return (Uint256(low=0, high=array[index]))
        end
        return (Uint256(0, 0))
    end
    let (p) = pow2(128 - 8 * rem)
    let (has_three) = is_le(index + 3, array_len)
    if has_three == 1:
        let (_, h1) = unsigned_div_rem(array[index], p)
        let (l1, h2) = unsigned_div_rem(array[index + 1], p)
        let (l2, _) = unsigned_div_rem(array[index + 2], p)
        return (Uint256(low=l2 + UINT128_BOUND * h2 / p, high=l1 + UINT128_BOUND * h1 / p))
    end
    if index + 2 == array_len:
        let (_, h1) = unsigned_div_rem(array[index], p)
        let (l1, h2) = unsigned_div_rem(array[index + 1], p)
        return (Uint256(low=UINT128_BOUND * h2 / p, high=l1 + UINT128_BOUND * h1 / p))
    end
    if index + 1 == array_len:
        let (_, h1) = unsigned_div_rem(array[index], p)
        return (Uint256(low=0, high=UINT128_BOUND * h1 / p))
    end
    return (Uint256(0, 0))
end

func validate_array{range_check_ptr}(array_size, array_len, array : felt*):
    # Verifies that all felts in the 'array' of length 'array_len' are
    # in the range [0, 2^128) and that the total number of bytes in
    # the 'array' is 'array_size'.
    if array_len == 0:
        return ()
    end
    assert [range_check_ptr] = array[0]
    let range_check_ptr = range_check_ptr + 1
    if array_len == 1:
        assert_nn_le(array_size, 16)
        let (p) = pow2(128 - 8 * array_size)
        let (_, remains) = unsigned_div_rem(array[0], p)
        assert remains = 0
        return ()
    else:
        return validate_array(array_size - 16, array_len - 1, array + 1)
    end
end
