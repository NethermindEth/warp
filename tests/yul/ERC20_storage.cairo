%lang starknet
%builtins pedersen range_check

from evm.memory import mload_, mstore_
from evm.sha3 import sha
from evm.uint256 import is_eq, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shr, uint256_sub)
from starkware.starknet.common.storage import Storage

@storage_var
func evm_storage(low : felt, high : felt, part : felt) -> (res : felt):
end

func s_load{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256) -> (res : Uint256):
    let (low_r) = evm_storage.read(key.low, key.high, 1)
    let (high_r) = evm_storage.read(key.low, key.high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        key : Uint256, value : Uint256):
    evm_storage.write(low=key.low, high=key.high, part=1, value=value.low)
    evm_storage.write(low=key.low, high=key.high, part=2, value=value.high)
    return ()
end

@view
func get_storage_low{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end

func __warp_block_00(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func abi_decode{range_check_ptr}(dataEnd : Uint256) -> ():
    alloc_locals
    local _1 : Uint256 = Uint256(low=0, high=0)
    let (local _2 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3 : Uint256) = u256_add(dataEnd, _2)
    local range_check_ptr = range_check_ptr
    let (local _4 : Uint256) = slt(_3, _1)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4)
    return ()
end

func abi_decode_uint256{range_check_ptr}(dataEnd_1 : Uint256) -> (value0 : Uint256):
    alloc_locals
    local _1_2 : Uint256 = Uint256(low=32, high=0)
    let (local _2_3 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_4 : Uint256) = u256_add(dataEnd_1, _2_3)
    local range_check_ptr = range_check_ptr
    let (local _4_5 : Uint256) = slt(_3_4, _1_2)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4_5)
    local _5 : Uint256 = Uint256(low=4, high=0)
    local value0 : Uint256 = Uint256(31597865, 9284653)
    return (value0)
end

func abi_decode_uint256t_uint256{range_check_ptr}(dataEnd_6 : Uint256) -> (
        value0_7 : Uint256, value1 : Uint256):
    alloc_locals
    local _1_8 : Uint256 = Uint256(low=64, high=0)
    let (local _2_9 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_10 : Uint256) = u256_add(dataEnd_6, _2_9)
    local range_check_ptr = range_check_ptr
    let (local _4_11 : Uint256) = slt(_3_10, _1_8)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4_11)
    local _5_12 : Uint256 = Uint256(low=4, high=0)
    local value0_7 : Uint256 = Uint256(31597865, 9284653)
    local _6 : Uint256 = Uint256(low=36, high=0)
    local value1 : Uint256 = Uint256(31597865, 9284653)
    return (value0_7, value1)
end

func abi_decode_uint256t_uint256t_uint256{range_check_ptr}(dataEnd_13 : Uint256) -> (
        value0_14 : Uint256, value1_15 : Uint256, value2 : Uint256):
    alloc_locals
    local _1_16 : Uint256 = Uint256(low=96, high=0)
    let (local _2_17 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_18 : Uint256) = u256_add(dataEnd_13, _2_17)
    local range_check_ptr = range_check_ptr
    let (local _4_19 : Uint256) = slt(_3_18, _1_16)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4_19)
    local _5_20 : Uint256 = Uint256(low=4, high=0)
    local value0_14 : Uint256 = Uint256(31597865, 9284653)
    local _6_21 : Uint256 = Uint256(low=36, high=0)
    local value1_15 : Uint256 = Uint256(31597865, 9284653)
    local _7 : Uint256 = Uint256(low=68, high=0)
    local value2 : Uint256 = Uint256(31597865, 9284653)
    return (value0_14, value1_15, value2)
end

func abi_decode_uint256t_uint256t_uint256t_uint256{range_check_ptr}(dataEnd_22 : Uint256) -> (
        value0_23 : Uint256, value1_24 : Uint256, value2_25 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_26 : Uint256 = Uint256(low=128, high=0)
    let (local _2_27 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_28 : Uint256) = u256_add(dataEnd_22, _2_27)
    local range_check_ptr = range_check_ptr
    let (local _4_29 : Uint256) = slt(_3_28, _1_26)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4_29)
    local _5_30 : Uint256 = Uint256(low=4, high=0)
    local value0_23 : Uint256 = Uint256(31597865, 9284653)
    local _6_31 : Uint256 = Uint256(low=36, high=0)
    local value1_24 : Uint256 = Uint256(31597865, 9284653)
    local _7_32 : Uint256 = Uint256(low=68, high=0)
    local value2_25 : Uint256 = Uint256(31597865, 9284653)
    local _8 : Uint256 = Uint256(low=100, high=0)
    local value3 : Uint256 = Uint256(31597865, 9284653)
    return (value0_23, value1_24, value2_25, value3)
end

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_33 : Uint256) = is_zero(value)
    local range_check_ptr = range_check_ptr
    let (local _2_34 : Uint256) = is_zero(_1_33)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos.low, value=_2_34)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256_to_uint256_1340{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_35 : Uint256) -> ():
    alloc_locals
    local _1_36 : Uint256 = Uint256(low=128, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_36.low, value=value_35)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_37 : Uint256, pos_38 : Uint256) -> ():
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_38.low, value=value_37)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint8_to_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        value_39 : Uint256, pos_40 : Uint256) -> ():
    alloc_locals
    local _1_41 : Uint256 = Uint256(low=255, high=0)
    let (local _2_42 : Uint256) = uint256_and(value_39, _1_41)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos_40.low, value=_2_42)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_43 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_44 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart, _1_44)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool{memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(
        value0_43, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func abi_encode_uint256_554{memory_dict : DictAccess*, msize, range_check_ptr}(
        value0_45 : Uint256) -> (tail_46 : Uint256):
    alloc_locals
    local tail_46 : Uint256 = Uint256(low=160, high=0)
    abi_encode_uint256_to_uint256_1340{memory_dict=memory_dict, msize=msize}(value0_45)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_46)
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_47 : Uint256, value0_48 : Uint256) -> (tail_49 : Uint256):
    alloc_locals
    local _1_50 : Uint256 = Uint256(low=32, high=0)
    let (local tail_49 : Uint256) = u256_add(headStart_47, _1_50)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256{memory_dict=memory_dict, msize=msize}(value0_48, headStart_47)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail_49)
end

func abi_encode_uint8{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart_51 : Uint256, value0_52 : Uint256) -> (tail_53 : Uint256):
    alloc_locals
    local _1_54 : Uint256 = Uint256(low=32, high=0)
    let (local tail_53 : Uint256) = u256_add(headStart_51, _1_54)
    local range_check_ptr = range_check_ptr
    abi_encode_uint8_to_uint8{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(
        value0_52, headStart_51)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail_53)
end

func checked_sub_uint256{range_check_ptr}(x_57 : Uint256, y_58 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_59 : Uint256) = is_lt(x_57, y_58)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_59)
    let (local diff : Uint256) = uint256_sub(x_57, y_58)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func cleanup_from_storage_uint256(value_60 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_60
    return (cleaned)
end

func extract_from_storage_value_dynamict_uint8{range_check_ptr}(slot_value : Uint256) -> (
        value_61 : Uint256):
    alloc_locals
    local _1_62 : Uint256 = Uint256(low=255, high=0)
    let (local value_61 : Uint256) = uint256_and(slot_value, _1_62)
    local range_check_ptr = range_check_ptr
    return (value_61)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_566{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_100 : Uint256) -> (
        dataSlot_101 : Uint256):
    alloc_locals
    local _1_102 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_102.low, value=key_100)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_103 : Uint256 = Uint256(low=3, high=0)
    local _3_104 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_104.low, value=_2_103)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_105 : Uint256 = Uint256(low=64, high=0)
    local _5_106 : Uint256 = _1_102
    let (local dataSlot_101 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_102.low, _4_105.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_101)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict : DictAccess*, msize, range_check_ptr}(slot : Uint256, key_121 : Uint256) -> (
        dataSlot_122 : Uint256):
    alloc_locals
    local _1_123 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_123.low, value=key_121)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_124 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_124.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_125 : Uint256 = Uint256(low=64, high=0)
    local _4_126 : Uint256 = _1_123
    let (local dataSlot_122 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_123.low, _3_125.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_122)
end

func update_byte_slice_shift(value_141 : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr : HashBuiltin*, storage_ptr : Storage*, range_check_ptr}(
        slot_142 : Uint256, value_143 : Uint256) -> ():
    alloc_locals
    let (local _1_144 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        slot_142)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _2_145 : Uint256) = update_byte_slice_shift(_1_144, value_143)
    s_store{storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        key=slot_142, value=_2_145)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return ()
end

func fun_approve{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        range_check_ptr}(var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (
        var_ : Uint256):
    alloc_locals
    let (
        local _1_63 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_566{
        memory_dict=memory_dict, msize=msize}(var_sender)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _2_64 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_1_63, var_guy)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_2_64, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_guy_low, var_guy_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var__low, var__high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var_) = fun_approve{memory_dict=memory_dict, msize=msize}(
        Uint256(var_guy_low, var_guy_high),
        Uint256(var_wad_low, var_wad_high),
        Uint256(var_sender_low, var_sender_high))
    return (var_.low, var_.high)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_107 : Uint256) -> (
        dataSlot_108 : Uint256):
    alloc_locals
    local _1_109 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_109.low, value=key_107)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_110 : Uint256 = Uint256(low=2, high=0)
    local _3_111 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_111.low, value=_2_110)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_112 : Uint256 = Uint256(low=64, high=0)
    local _5_113 : Uint256 = _1_109
    let (local dataSlot_108 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_109.low, _4_112.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_108)
end

func fun_deposit{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_sender_65 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (
        local _1_66 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_sender_65)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_67 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_1_66)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _3_68 : Uint256) = cleanup_from_storage_uint256(_2_67)
    let (local _4_69 : Uint256) = u256_add(_3_68, var_value)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_1_66, _4_69)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_65_low, var_sender_65_high, var_value_low, var_value_high) -> ():
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    fun_deposit{memory_dict=memory_dict, msize=msize}(
        Uint256(var_sender_65_low, var_sender_65_high), Uint256(var_value_low, var_value_high))
    return ()
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, storage_ptr : Storage*, range_check_ptr}(
        slot_133 : Uint256) -> (value_134 : Uint256):
    alloc_locals
    let (local _1_135 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        slot_133)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local value_134 : Uint256) = cleanup_from_storage_uint256(_1_135)
    return (value_134)
end

func fun_get_balance{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        range_check_ptr}(var_src : Uint256) -> (var : Uint256):
    alloc_locals
    let (
        local _1_70 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local var : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_1_70)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var)
end

@external
func fun_get_balance_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src_low, var_src_high) -> (var_low, var_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var) = fun_get_balance{memory_dict=memory_dict, msize=msize}(
        Uint256(var_src_low, var_src_high))
    return (var.low, var.high)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_136 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_136)
    return ()
end

func __warp_block_2{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_sender_73 : Uint256, var_src_71 : Uint256, var_wad_72 : Uint256) -> ():
    alloc_locals
    let (
        local _3_77 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_566{
        memory_dict=memory_dict, msize=msize}(var_src_71)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _4_78 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_3_77, var_sender_73)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _5_79 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_4_78)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _6_80 : Uint256) = is_lt(_5_79, var_wad_72)
    local range_check_ptr = range_check_ptr
    let (local _7_81 : Uint256) = is_zero(_6_80)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_7_81)
    local range_check_ptr = range_check_ptr
    let (
        local _8_82 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_src_71)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _9 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_8_82)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _10 : Uint256) = cleanup_from_storage_uint256(_9)
    let (local _11 : Uint256) = is_lt(_10, var_wad_72)
    local range_check_ptr = range_check_ptr
    let (local _12 : Uint256) = is_zero(_11)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_12)
    local range_check_ptr = range_check_ptr
    let (
        local _13 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_566{
        memory_dict=memory_dict, msize=msize}(var_src_71)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _14 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_13, var_sender_73)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _15 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_14)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _16 : Uint256) = cleanup_from_storage_uint256(_15)
    let (local _17 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _16, var_wad_72)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_14, _17)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_0_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _2_76 : Uint256, var_sender_73 : Uint256, var_src_71 : Uint256, var_wad_72 : Uint256) -> ():
    alloc_locals
    if _2_76.low + _2_76.high != 0:
        __warp_block_2{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(var_sender_73, var_src_71, var_wad_72)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_src_71 : Uint256, var_dst : Uint256, var_wad_72 : Uint256, var_sender_73 : Uint256) -> (
        var_74 : Uint256):
    alloc_locals
    let (local _1_75 : Uint256) = is_eq(var_src_71, var_sender_73)
    local range_check_ptr = range_check_ptr
    let (local _2_76 : Uint256) = is_zero(_1_75)
    local range_check_ptr = range_check_ptr
    __warp_block_0_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_76, var_sender_73, var_src_71, var_wad_72)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (
        local _18 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_src_71)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _19 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_18)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _20 : Uint256) = cleanup_from_storage_uint256(_19)
    let (local _21 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _20, var_wad_72)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_18, _21)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (
        local _22 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_dst)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _23 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_22)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _24 : Uint256) = cleanup_from_storage_uint256(_23)
    let (local _25 : Uint256) = u256_add(_24, var_wad_72)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_22, _25)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_74 : Uint256 = Uint256(low=1, high=0)
    return (var_74)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src_71_low, var_src_71_high, var_dst_low, var_dst_high, var_wad_72_low,
        var_wad_72_high, var_sender_73_low, var_sender_73_high) -> (var_74_low, var_74_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var_74) = fun_transferFrom{memory_dict=memory_dict, msize=msize}(
        Uint256(var_src_71_low, var_src_71_high),
        Uint256(var_dst_low, var_dst_high),
        Uint256(var_wad_72_low, var_wad_72_high),
        Uint256(var_sender_73_low, var_sender_73_high))
    return (var_74.low, var_74.high)
end

func fun_withdraw{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_wad_83 : Uint256, var_sender_84 : Uint256) -> ():
    alloc_locals
    let (
        local _1_85 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_sender_84)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_86 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_1_85)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_87 : Uint256) = is_lt(_2_86, var_wad_83)
    local range_check_ptr = range_check_ptr
    let (local _4_88 : Uint256) = is_zero(_3_87)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_4_88)
    local range_check_ptr = range_check_ptr
    let (
        local _5_89 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        memory_dict=memory_dict, msize=msize}(var_sender_84)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _6_90 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_5_89)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _7_91 : Uint256) = cleanup_from_storage_uint256(_6_90)
    let (local _8_92 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _7_91, var_wad_83)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_5_89, _8_92)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_83_low, var_wad_83_high, var_sender_84_low, var_sender_84_high) -> ():
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    fun_withdraw{memory_dict=memory_dict, msize=msize}(
        Uint256(var_wad_83_low, var_wad_83_high), Uint256(var_sender_84_low, var_sender_84_high))
    return ()
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_576{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_114 : Uint256) -> (
        dataSlot_115 : Uint256):
    alloc_locals
    local _1_116 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_116.low, value=key_114)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_117 : Uint256 = Uint256(low=2, high=0)
    local _3_118 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_118.low, value=_2_117)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_119 : Uint256 = Uint256(low=64, high=0)
    local _5_120 : Uint256 = _1_116
    let (local dataSlot_115 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_116.low, _4_119.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_115)
end

func getter_fun_balanceOf{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        range_check_ptr}(key : Uint256) -> (ret__warp_mangled : Uint256):
    alloc_locals
    let (
        local _1_93 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_576{
        memory_dict=memory_dict, msize=msize}(key)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local ret__warp_mangled : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_1_93)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (ret__warp_mangled)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_563{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_94 : Uint256) -> (
        dataSlot : Uint256):
    alloc_locals
    local _1_95 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_95.low, value=key_94)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_96 : Uint256 = Uint256(low=3, high=0)
    local _3_97 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_97.low, value=_2_96)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_98 : Uint256 = Uint256(low=64, high=0)
    local _5_99 : Uint256 = _1_95
    let (local dataSlot : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(_1_95.low, _4_98.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot)
end

func __warp_block_7{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_147 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _11_156 : Uint256 = Uint256(0, 0)
    __warp_block_00(_11_156)
    local _12_157 : Uint256 = _4_149
    abi_decode{range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    let (local _13_158 : Uint256) = uint256_not(Uint256(low=127, high=0))
    local range_check_ptr = range_check_ptr
    local _14_159 : Uint256 = Uint256(low=1, high=0)
    let (local _15_160 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        _14_159)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _16_161 : Uint256) = cleanup_from_storage_uint256(_15_160)
    let (local _17_162 : Uint256) = abi_encode_uint256_554{memory_dict=memory_dict, msize=msize}(
        _16_161)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _18_163 : Uint256) = u256_add(_17_162, _13_158)
    local range_check_ptr = range_check_ptr
    local _19_164 : Uint256 = _2_147

    return ()
end

func __warp_block_10{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256) -> ():
    alloc_locals
    local _20_165 : Uint256 = Uint256(0, 0)
    __warp_block_00(_20_165)
    local _21_166 : Uint256 = _4_149
    abi_decode{range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    local _22_167 : Uint256 = _7_152
    let (local _23_168 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_7_152)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local ret_169 : Uint256) = extract_from_storage_value_dynamict_uint8{
        range_check_ptr=range_check_ptr}(_23_168)
    local range_check_ptr = range_check_ptr
    let (local memPos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _24_170 : Uint256) = abi_encode_uint8{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos, ret_169)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _25_171 : Uint256) = uint256_sub(_24_170, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_13{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256) -> ():
    alloc_locals
    local _26 : Uint256 = _4_149
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    fun_withdraw{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(param, param_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _27 : Uint256 = _7_152
    let (local _28 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    return ()
end

func __warp_block_16{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _29 : Uint256 = Uint256(0, 0)
    __warp_block_00(_29)
    local _30 : Uint256 = _4_149
    let (local _31 : Uint256) = abi_decode_uint256{range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    let (local ret_1 : Uint256) = fun_get_balance{
        memory_dict=memory_dict, msize=msize, pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(
        _31)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_1 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _32 : Uint256) = abi_encode_uint256{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _33 : Uint256) = uint256_sub(_32, memPos_1)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_19{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _34 : Uint256 = _4_149
    let (local param_2 : Uint256, local param_3 : Uint256, local param_4 : Uint256,
        local param_5 : Uint256) = abi_decode_uint256t_uint256t_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    let (local ret_2 : Uint256) = fun_transferFrom{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(param_2, param_3, param_4, param_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_2 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _35 : Uint256) = abi_encode_bool{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos_2, ret_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _36 : Uint256) = uint256_sub(_35, memPos_2)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_22{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _37 : Uint256 = Uint256(0, 0)
    __warp_block_00(_37)
    local _38 : Uint256 = _4_149
    let (local _39 : Uint256) = abi_decode_uint256{range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    let (local ret_3 : Uint256) = getter_fun_balanceOf{
        memory_dict=memory_dict, msize=msize, pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(
        _39)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_3 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _40 : Uint256) = abi_encode_uint256{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos_3, ret_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _41 : Uint256) = uint256_sub(_40, memPos_3)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_25{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _42 : Uint256 = _4_149
    let (local param_6 : Uint256, local param_7 : Uint256,
        local param_8 : Uint256) = abi_decode_uint256t_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    let (local ret_4 : Uint256) = fun_approve{
        memory_dict=memory_dict, msize=msize, pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(
        param_6, param_7, param_8)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_4 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _43 : Uint256) = abi_encode_bool{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos_4, ret_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _44 : Uint256) = uint256_sub(_43, memPos_4)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_28{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _45 : Uint256 = Uint256(0, 0)
    __warp_block_00(_45)
    local _46 : Uint256 = _4_149
    let (local param_9 : Uint256, local param_10 : Uint256) = abi_decode_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    let (
        local _47 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_563{
        memory_dict=memory_dict, msize=msize}(param_9)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _48 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_47, param_10)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local ret_5 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_48)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local memPos_5 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _49 : Uint256) = abi_encode_uint256{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos_5, ret_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _50 : Uint256) = uint256_sub(_49, memPos_5)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_31{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256) -> ():
    alloc_locals
    local _51 : Uint256 = _4_149
    let (local param_11 : Uint256, local param_12 : Uint256) = abi_decode_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_149)
    local range_check_ptr = range_check_ptr
    fun_deposit{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(param_11, param_12)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _52 : Uint256 = _7_152
    let (local _53 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_1_146.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    return ()
end

func __warp_block_30_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_31{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_29{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3803951448, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_30_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_27_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_28{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_29{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_26{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3433131944, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_27_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_24_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_25{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_26{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_23{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3093743780, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_24_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_21_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_22{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_23{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_20{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2630350600, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_21_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_18_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_19{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_20{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_17{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2287400825, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_18_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_15_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_16{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_17{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_14{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1530952232, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_15_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_12_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_13{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_14{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_11{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=1142570608, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_12_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_9_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, __warp_subexpr_0 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_10{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_11{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_8{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _4_149 : Uint256, _7_152 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=826074471, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_9_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_6_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _2_147 : Uint256, _4_149 : Uint256, _7_152 : Uint256,
        __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_7{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_2_147, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_8{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _4_149, _7_152, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_5{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _2_147 : Uint256, _4_149 : Uint256, _7_152 : Uint256,
        match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=404098525, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_6_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _2_147, _4_149, _7_152, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_4{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _10_155 : Uint256, _1_146 : Uint256, _2_147 : Uint256, _4_149 : Uint256,
        _7_152 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10_155
    __warp_block_5{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _2_147, _4_149, _7_152, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_3{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_1_146 : Uint256, _2_147 : Uint256, _4_149 : Uint256) -> ():
    alloc_locals
    local _7_152 : Uint256 = Uint256(low=0, high=0)
    local _8_153 : Uint256 = Uint256(31597865, 9284653)
    local _9_154 : Uint256 = Uint256(low=224, high=0)
    let (local _10_155 : Uint256) = uint256_shr(_9_154, _8_153)
    local range_check_ptr = range_check_ptr
    __warp_block_4{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_10_155, _1_146, _2_147, _4_149, _7_152)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_1_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _1_146 : Uint256, _2_147 : Uint256, _4_149 : Uint256, _6_151 : Uint256) -> ():
    alloc_locals
    if _6_151.low + _6_151.high != 0:
        __warp_block_3{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_1_146, _2_147, _4_149)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        return ()
    end
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        ) -> ():
    alloc_locals
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    local _1_146 : Uint256 = Uint256(low=64, high=0)
    local _2_147 : Uint256 = Uint256(low=128, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_146.low, value=_2_147)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_148 : Uint256 = Uint256(low=4, high=0)
    local _4_149 : Uint256 = Uint256(31597865, 9284653)
    let (local _5_150 : Uint256) = is_lt(_4_149, _3_148)
    local range_check_ptr = range_check_ptr
    let (local _6_151 : Uint256) = is_zero(_5_150)
    local range_check_ptr = range_check_ptr
    __warp_block_1_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_1_146, _2_147, _4_149, _6_151)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr

    return ()
end
