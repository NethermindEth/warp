from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.math import assert_lt, assert_le, unsigned_div_rem
from starkware.cairo.common.uint256 import Uint256

from evm.utils import round_down_to_multiple

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
    let lower_overlap = lower + 16 - offset
    let (lower_v) = dict_read{dict_ptr=memory_dict}(lower)
    local memory_dict: DictAccess* = memory_dict
    let (lower_v) = replace_lower_bytes(lower_v, value, lower_overlap)
    dict_write{dict_ptr=memory_dict}(lower, lower_v)

    if lower_overlap == 16:
        return ()
    end

    let higher = lower + 16
    let higher_overlap = 16 - lower_overlap
    let (local higher_v) = dict_read{dict_ptr=memory_dict}(higher)
    local memory_dict: DictAccess* = memory_dict
    let (higher_v) = replace_higher_bytes(higher_v, value, higher_overlap)
    dict_write{dict_ptr=memory_dict}(higher, higher_v)
    return ()
end

func read_uint128{memory_dict: DictAccess*, range_check_ptr}(offset) -> (value):
    alloc_locals
    let value = 0

    let (local lower) = round_down_to_multiple(offset, 16)
    local lower_overlap = lower + 16 - offset
    let (lower_v) = dict_read{dict_ptr=memory_dict}(lower)
    local memory_dict: DictAccess* = memory_dict
    let (value) = replace_higher_bytes(value, lower_v, lower_overlap)

    if lower_overlap == 16:
        return (value)
    end

    let higher = lower + 16
    let higher_overlap = 16 - lower_overlap
    let (higher_v) = dict_read{dict_ptr=memory_dict}(higher)
    local memory_dict: DictAccess* = memory_dict
    let (value) = replace_lower_bytes(value, higher_v, higher_overlap)

    return (value)
end

func exp_byte(d) -> (res):
    # Compute '256^d'. Very slow, but we expect 'd' to be ≤ 16. The
    # fast version would require hints and they aren't allowed on
    # starknet. We can actually make a jump table... hmmm
    if d == 0:
        return (1)
    else:
        exp_byte(d - 1)
        return ([ap - 1] * 256)
    end
end

func replace_lower_bytes{range_check_ptr}(a, b, n) -> (res):
    # Replace 'n' lower _bytes_ of 'a' with 'n' higher _bytes_ of
    # 'b'. Assume, 'a' and 'b' are 128-bit (16-byte) wide.
    alloc_locals
    let (_, local high) = split_on_byte(a, n)
    let (_, local low) = split_on_byte(b, 16 - n)
    local range_check_ptr = range_check_ptr
    let (d) = exp_byte(n)
    return (high * d + low)
end

func replace_higher_bytes{range_check_ptr}(a, b, n) -> (res):
    # Replace 'n' higher _bytes_ of 'a' with 'n' lower _bytes_ of
    # 'b'. Assume, 'a' and 'b' are 128-bit (16-byte) wide.
    alloc_locals
    let (local low, _) = split_on_byte(a, 16 - n)
    let (local high, _) = split_on_byte(b, n)
    local range_check_ptr = range_check_ptr
    let (co_d) = exp_byte(16 - n)
    return (high * co_d + low)
end

func split_on_byte{range_check_ptr}(value, byte_pos) -> (low, high):
    # For a 128-bit integer 'value' return its 'byte_pos' lower bytes
    # and '16 - byte_pos' higher bytes.
    alloc_locals

    # 'unsigned_div_rem' can't handle 256**16
    if byte_pos == 16:
        return (value, 0)
    end
    assert_lt(byte_pos, 16)
    local range_check_ptr = range_check_ptr
    let (d) = exp_byte(byte_pos)
    let (q, r) = unsigned_div_rem(value, d)
    return (low=r, high=q)
end
