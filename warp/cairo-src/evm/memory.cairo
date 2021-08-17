from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.math import assert_lt, unsigned_div_rem
from starkware.cairo.common.uint256 import Uint256

from evm.bit_packing import (
    exp_byte, split_on_byte, extract_byte, put_byte, extract_unaligned_uint128,
    put_unaligned_uint128)

# Memory is packed 16 bytes per felt. Valid addresses/keys are 0, 16,
# 32, 48 etc. The layout is big-endian.

func mstore8{memory_dict : DictAccess*, range_check_ptr}(offset, byte):
    alloc_locals

    # value is supposed to be 1 byte
    assert_lt(byte, 256)

    let (local index, local rem) = unsigned_div_rem(offset, 16)
    let (local block) = dict_read{dict_ptr=memory_dict}(index * 16)
    local memory_dict : DictAccess* = memory_dict

    local byte_pos = 15 - rem
    let (low, _, high) = extract_byte(block, byte_pos)
    local range_check_ptr = range_check_ptr
    let (block) = put_byte(byte_pos, low, byte, high)

    dict_write{dict_ptr=memory_dict}(index * 16, block)
    return ()
end

func mload8{memory_dict : DictAccess*, range_check_ptr}(offset) -> (byte):
    alloc_locals

    let (index, rem) = unsigned_div_rem(offset, 16)
    let (block) = dict_read{dict_ptr=memory_dict}(index * 16)
    local memory_dict : DictAccess* = memory_dict

    let byte_pos = 15 - rem
    let (_, byte, _) = extract_byte(block, byte_pos)

    return (byte)
end

func mstore{memory_dict : DictAccess*, range_check_ptr}(offset, value : Uint256):
    alloc_locals
    let (local index, local rem) = unsigned_div_rem(offset, 16)
    if rem == 0:
        dict_write{dict_ptr=memory_dict}(index * 16, value.high)
        dict_write{dict_ptr=memory_dict}(index * 16 + 16, value.low)
        return ()
    end
    let (high) = dict_read{dict_ptr=memory_dict}(index * 16)
    let (mid) = dict_read{dict_ptr=memory_dict}(index * 16 + 16)
    let (local low) = dict_read{dict_ptr=memory_dict}(index * 16 + 32)
    local memory_dict : DictAccess* = memory_dict
    let (local _mid, local _high) = put_unaligned_uint128(
        shift=rem, low=mid, high=high, value=value.high)
    let (_low, _mid) = put_unaligned_uint128(shift=rem, low=low, high=_mid, value=value.low)
    dict_write{dict_ptr=memory_dict}(index * 16, _high)
    dict_write{dict_ptr=memory_dict}(index * 16 + 16, _mid)
    dict_write{dict_ptr=memory_dict}(index * 16 + 32, _low)
    return ()
end

func mload{memory_dict : DictAccess*, range_check_ptr}(offset) -> (value : Uint256):
    alloc_locals
    let (index, local rem) = unsigned_div_rem(offset, 16)
    let (high) = dict_read{dict_ptr=memory_dict}(index * 16)
    let (local mid) = dict_read{dict_ptr=memory_dict}(index * 16 + 16)
    if rem == 0:
        return (Uint256(low=mid, high=high))
    end
    let (local low) = dict_read{dict_ptr=memory_dict}(index * 16 + 32)
    local memory_dict : DictAccess* = memory_dict
    let (local unaligned_high) = extract_unaligned_uint128(shift=rem, low=mid, high=high)
    let (unaligned_low) = extract_unaligned_uint128(shift=rem, low=low, high=mid)
    return (Uint256(low=unaligned_low, high=unaligned_high))
end
