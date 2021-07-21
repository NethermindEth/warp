from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.math import assert_lt
from starkware.cairo.common.uint256 import Uint256

from evm.bit_packing import (
    exp_byte,
    split_on_byte,
    read_uint128 as general_read_uint128,
    write_uint128 as general_write_uint128,
    )
from evm.utils import round_down_to_multiple, round_up_to_multiple

# Memory is packed 16 bytes per felt. Valid addresses/keys are 0, 16,
# 32, 48 etc. The layout is big-endian.

func mstore8{memory_dict: DictAccess*, range_check_ptr}(offset, byte):
    alloc_locals

    # value is supposed to be 1 byte
    assert_lt(byte, 256)

    let (local place) = round_down_to_multiple(offset, 16)
    let (local pack) = dict_read{dict_ptr=memory_dict}(place)
    local memory_dict: DictAccess* = memory_dict

    local byte_pos = 15 - (offset - place)
    let (low, _, high) = extract_byte(pack, byte_pos)
    local range_check_ptr = range_check_ptr
    let (pack) = put_byte(byte_pos, low, byte, high)

    dict_write{dict_ptr=memory_dict}(place, pack)
    return ()
end

func mload8{memory_dict: DictAccess*, range_check_ptr}(offset) -> (byte):
    alloc_locals

    let (place) = round_down_to_multiple(offset, 16)
    let (pack) = dict_read{dict_ptr=memory_dict}(place)
    local memory_dict: DictAccess* = memory_dict

    let byte_pos = 15 - (offset - place)
    let (_, byte, _) = extract_byte(pack, byte_pos)

    return (byte)
end

func extract_byte{range_check_ptr}(x, pos) -> (low, byte, high):
    alloc_locals
    let (local low, rest) = split_on_byte(x, pos)
    let (byte, high) = split_on_byte(rest, 1)
    return (low, byte, high)
end

func put_byte(pos, low, byte, high) -> (x):
    let (d) = exp_byte(pos)
    return ((high * 256 + byte) * d + low)
end

func mstore{memory_dict: DictAccess*, range_check_ptr}(offset, value: Uint256):
    write_uint128(offset, value.high) # big-endian
    write_uint128(offset + 16, value.low)
    return ()
end

func mload{memory_dict: DictAccess*, range_check_ptr}(offset) -> (value: Uint256):
    alloc_locals
    let (local high) = read_uint128(offset)
    let (low) = read_uint128(offset + 16)
    return (Uint256(low, high))
end

func write_uint128{memory_dict: DictAccess*, range_check_ptr}(offset, value):
    alloc_locals
    let (local lower) = round_down_to_multiple(offset, 16)
    local higher = lower + 16
    let (lower_v) = dict_read{dict_ptr=memory_dict}(lower)
    let (higher_v) = dict_read{dict_ptr=memory_dict}(higher)
    local memory_dict: DictAccess* = memory_dict
    let (lower_v, higher_v) = general_write_uint128(offset, lower_v, higher_v, value)
    dict_write{dict_ptr=memory_dict}(lower, lower_v)
    dict_write{dict_ptr=memory_dict}(higher, higher_v)
    return ()
end

func read_uint128{memory_dict: DictAccess*, range_check_ptr}(offset) -> (value):
    alloc_locals
    let (lower) = round_down_to_multiple(offset, 16)
    let (higher) = round_up_to_multiple(offset, 16)
    let (lower_v) = dict_read{dict_ptr=memory_dict}(lower)
    let (higher_v) = dict_read{dict_ptr=memory_dict}(higher)
    local memory_dict: DictAccess* = memory_dict
    let (res) = general_read_uint128(offset, lower_v, higher_v)
    return (res)
end
