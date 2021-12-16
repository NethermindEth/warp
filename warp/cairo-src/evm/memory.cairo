from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import assert_lt, unsigned_div_rem
from starkware.cairo.common.uint256 import Uint256

from evm.bit_packing import (
    exp_byte, extract_byte, extract_unaligned_uint128, put_byte, put_unaligned_uint128,
    split_on_byte)
from evm.uint256 import extract_lowest_byte
from evm.utils import round_up_to_multiple, update_msize

# A module for work with the EVM memory.

# Memory 'memory_dict' is packed 16 bytes per felt. Valid
# addresses/keys are 0, 16, 32, 48 etc. The layout is big-endian.

func mstore8{memory_dict : DictAccess*, range_check_ptr}(offset, byte):
    # Put a byte 'byte' into memory at the 'offset' index.
    alloc_locals

    # value is supposed to be 1 byte
    assert_lt(byte, 256)

    let (index, rem) = unsigned_div_rem(offset, 16)
    let (block) = dict_read{dict_ptr=memory_dict}(index * 16)
    let byte_pos = 15 - rem
    let (low, _, high) = extract_byte(block, byte_pos)
    let (block) = put_byte(byte_pos, low, byte, high)
    dict_write{dict_ptr=memory_dict}(index * 16, block)
    return ()
end

func mload8{memory_dict : DictAccess*, range_check_ptr}(offset) -> (byte):
    # Load a byte 'byte' from memory at the 'offset' index.
    alloc_locals
    let (index, rem) = unsigned_div_rem(offset, 16)
    let (block) = dict_read{dict_ptr=memory_dict}(index * 16)
    let byte_pos = 15 - rem
    let (_, byte, _) = extract_byte(block, byte_pos)
    return (byte)
end

func mstore{memory_dict : DictAccess*, range_check_ptr}(offset, value : Uint256):
    # Store a 256-bit value 'value' in memory, starting with the
    # 'offset' index.
    alloc_locals
    let (index, rem) = unsigned_div_rem(offset, 16)
    if rem == 0:
        dict_write{dict_ptr=memory_dict}(index * 16, value.high)
        dict_write{dict_ptr=memory_dict}(index * 16 + 16, value.low)
        return ()
    end
    let (high) = dict_read{dict_ptr=memory_dict}(index * 16)
    let (mid) = dict_read{dict_ptr=memory_dict}(index * 16 + 16)
    let (low) = dict_read{dict_ptr=memory_dict}(index * 16 + 32)
    let (_mid, _high) = put_unaligned_uint128(shift=rem, low=mid, high=high, value=value.high)
    let (_low, _mid) = put_unaligned_uint128(shift=rem, low=low, high=_mid, value=value.low)
    dict_write{dict_ptr=memory_dict}(index * 16, _high)
    dict_write{dict_ptr=memory_dict}(index * 16 + 16, _mid)
    dict_write{dict_ptr=memory_dict}(index * 16 + 32, _low)
    return ()
end

func mload{memory_dict : DictAccess*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(offset) -> (
        value : Uint256):
    # Load a 256-bit value 'value' from memory, starting with the
    # 'offset' index.
    alloc_locals
    let (index, rem) = unsigned_div_rem(offset, 16)
    let (high) = dict_read{dict_ptr=memory_dict}(index * 16)
    let (mid) = dict_read{dict_ptr=memory_dict}(index * 16 + 16)
    if rem == 0:
        return (Uint256(low=mid, high=high))
    end
    let (low) = dict_read{dict_ptr=memory_dict}(index * 16 + 32)
    let (unaligned_high) = extract_unaligned_uint128(shift=rem, low=mid, high=high)
    let (unaligned_low) = extract_unaligned_uint128(shift=rem, low=low, high=mid)
    return (Uint256(low=unaligned_low, high=unaligned_high))
end

func mstore8_{memory_dict : DictAccess*, range_check_ptr, msize}(offset, value : Uint256):
    # Extracts lower byte of 'value' and does 'mstore8' on it. Also updates 'msize'.
    alloc_locals
    let (byte, _) = extract_lowest_byte(value)
    let (msize) = update_msize(msize, offset, 1)
    mstore8(offset, byte)
    return ()
end

func uint256_mstore8{memory_dict : DictAccess*, range_check_ptr, msize}(
        offset : Uint256, value : Uint256):
    # Does what 'mstore8_' does, but with Uint256 arguments for
    # convenient use in the transpiled code.
    return mstore8_(offset.low, value)
end

func mstore_{memory_dict : DictAccess*, range_check_ptr, msize}(offset, value : Uint256):
    # Does what 'mstore' does but also updates 'msize'.
    alloc_locals
    let (msize) = update_msize(msize, offset, 32)
    mstore(offset, value)
    return ()
end

func uint256_mstore{memory_dict : DictAccess*, range_check_ptr, msize}(
        offset : Uint256, value : Uint256):
    # Does what 'mstore_' does, but with Uint256 arguments for
    # convenient use in the transpiled code.
    return mstore_(offset.low, value)
end

func mload_{memory_dict : DictAccess*, range_check_ptr, msize, bitwise_ptr : BitwiseBuiltin*}(
        offset) -> (value : Uint256):
    # Does what 'mload' does but also updates 'msize'.
    alloc_locals
    let (msize) = update_msize(msize, offset, 32)
    let (value : Uint256) = mload(offset)
    return (value=value)
end

func uint256_mload{
        memory_dict : DictAccess*, range_check_ptr, msize, bitwise_ptr : BitwiseBuiltin*}(
        offset : Uint256) -> (value : Uint256):
    # Does what 'mload_' does, but with Uint256 arguments for
    # convenient use in the transpiled code.
    return mload_(offset.low)
end

func get_msize{range_check_ptr, msize}() -> (value : Uint256):
    # Returns 'msize' rounded up to the nearest word, as per the yellow paper.
    let (immediate) = round_up_to_multiple(msize, 32)
    return Uint256(immediate, 0)
end
