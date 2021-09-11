%lang starknet
%builtins pedersen range_check

from evm.memory import mstore_
from evm.sha3 import sha
from evm.uint256 import is_eq, is_lt, is_zero, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_and, uint256_eq, uint256_sub
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

func __warp_block_0_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_1_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_4_5 : Uint256) -> ():
    alloc_locals
    if _4_5.low + _4_5.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_2_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_4_11 : Uint256) -> ():
    alloc_locals
    if _4_11.low + _4_11.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_3_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_4_19 : Uint256) -> ():
    alloc_locals
    if _4_19.low + _4_19.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_4_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_4_29 : Uint256) -> ():
    alloc_locals
    if _4_29.low + _4_29.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_5_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_2_63 : Uint256) -> ():
    alloc_locals
    if _2_63.low + _2_63.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func __warp_block_6_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_1_66 : Uint256) -> ():
    alloc_locals
    if _1_66.low + _1_66.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_sub_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(x_64 : Uint256, y_65 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_66 : Uint256) = is_lt(x_64, y_65)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    __warp_block_6_if(_1_66)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local diff : Uint256) = uint256_sub(x_64, y_65)
    return (diff)
end

func cleanup_from_storage_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(value_67 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_67
    return (cleaned)
end

func extract_from_storage_value_dynamict_uint8{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_value : Uint256) -> (value_68 : Uint256):
    alloc_locals
    local _1_69 : Uint256 = Uint256(low=255, high=0)
    let (local value_68 : Uint256) = uint256_and(slot_value, _1_69)
    return (value_68)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_106 : Uint256) -> (dataSlot_107 : Uint256):
    alloc_locals
    local _1_108 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=_1_108.low, value=key_106)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_109 : Uint256 = Uint256(low=3, high=0)
    local _3_110 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=_3_110.low, value=_2_109)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_111 : Uint256 = Uint256(low=64, high=0)
    local _5_112 : Uint256 = _1_108
    let (local dataSlot_107 : Uint256) = sha(_1_108.low, _4_111.low)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_107)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_127 : Uint256) -> (
        dataSlot_128 : Uint256):
    alloc_locals
    local _1_129 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=_1_129.low, value=key_127)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_130 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=_2_130.low, value=slot)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_131 : Uint256 = Uint256(low=64, high=0)
    local _4_132 : Uint256 = _1_129
    let (local dataSlot_128 : Uint256) = sha(_1_129.low, _3_131.low)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_128)
end

func update_byte_slice_shift{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(value_147 : Uint256, toInsert : Uint256) -> (
        result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_148 : Uint256, value_149 : Uint256) -> ():
    alloc_locals
    let (local _1_150 : Uint256) = s_load(slot_148)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_151 : Uint256) = update_byte_slice_shift(_1_150, value_149)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    s_store(key=slot_148, value=_2_151)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func fun_approve{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    let (
        local _1_70 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570(
        var_sender)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _2_71 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _1_70, var_guy)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256(_2_71, var_wad)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_approve_external{range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_guy_low, var_guy_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var_low, var_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var) = fun_approve{memory_dict=memory_dict, msize=msize}(
        Uint256(var_guy_low, var_guy_high),
        Uint256(var_wad_low, var_wad_high),
        Uint256(var_sender_low, var_sender_high))
    return (var.low, var.high)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_113 : Uint256) -> (dataSlot_114 : Uint256):
    alloc_locals
    local _1_115 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=_1_115.low, value=key_113)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_116 : Uint256 = Uint256(low=2, high=0)
    local _3_117 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=_3_117.low, value=_2_116)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_118 : Uint256 = Uint256(low=64, high=0)
    local _5_119 : Uint256 = _1_115
    let (local dataSlot_114 : Uint256) = sha(_1_115.low, _4_118.low)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_114)
end

func fun_deposit{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_sender_72 : Uint256, var_value : Uint256) -> (
        var_73 : Uint256, var_ : Uint256):
    alloc_locals
    let (
        local _1_74 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_sender_72)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_75 : Uint256) = s_load(_1_74)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _3_76 : Uint256) = cleanup_from_storage_uint256(_2_75)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _4_77 : Uint256) = u256_add(_3_76, var_value)
    update_storage_value_offsett_uint256_to_uint256(_1_74, _4_77)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local var_73 : Uint256 = Uint256(low=21, high=0)
    local var_ : Uint256 = Uint256(low=12, high=0)
    return (var_73, var_)
end

@external
func fun_deposit_external{range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_sender_72_low, var_sender_72_high, var_value_low, var_value_high) -> (
        var_73_low, var_73_high, var__low, var__high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var_73, var_) = fun_deposit{memory_dict=memory_dict, msize=msize}(
        Uint256(var_sender_72_low, var_sender_72_high), Uint256(var_value_low, var_value_high))
    return (var_73.low, var_73.high, var_.low, var_.high)
end

func read_from_storage_split_dynamic_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_139 : Uint256) -> (value_140 : Uint256):
    alloc_locals
    let (local _1_141 : Uint256) = s_load(slot_139)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local value_140 : Uint256) = cleanup_from_storage_uint256(_1_141)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (value_140)
end

func __warp_block_8_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_1_142 : Uint256) -> ():
    alloc_locals
    if _1_142.low + _1_142.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func require_helper{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_142 : Uint256) = is_zero(condition)
    __warp_block_8_if(_1_142)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func __warp_block_9{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_sender_79 : Uint256, var_src : Uint256, var_wad_78 : Uint256) -> ():
    alloc_locals
    let (
        local _3_83 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570(
        var_src)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _4_84 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _3_83, var_sender_79)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _5_85 : Uint256) = read_from_storage_split_dynamic_uint256(_4_84)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _6_86 : Uint256) = is_lt(_5_85, var_wad_78)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_87 : Uint256) = is_zero(_6_86)
    require_helper(_7_87)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _8_88 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_src)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _9 : Uint256) = read_from_storage_split_dynamic_uint256(_8_88)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _10 : Uint256) = cleanup_from_storage_uint256(_9)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _11 : Uint256) = is_lt(_10, var_wad_78)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _12 : Uint256) = is_zero(_11)
    require_helper(_12)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _13 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570(
        var_src)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _14 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _13, var_sender_79)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _15 : Uint256) = s_load(_14)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _16 : Uint256) = cleanup_from_storage_uint256(_15)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _17 : Uint256) = checked_sub_uint256(_16, var_wad_78)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256(_14, _17)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func __warp_block_7_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        _2_82 : Uint256, var_sender_79 : Uint256, var_src : Uint256, var_wad_78 : Uint256) -> ():
    alloc_locals
    if _2_82.low + _2_82.high != 0:
        __warp_block_9(var_sender_79, var_src, var_wad_78)
        local range_check_ptr = range_check_ptr
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local storage_ptr : Storage* = storage_ptr
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        return ()
    else:
        return ()
    end
end

func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_src : Uint256, var_dst : Uint256, var_wad_78 : Uint256, var_sender_79 : Uint256) -> (
        var_80 : Uint256):
    alloc_locals
    let (local _1_81 : Uint256) = is_eq(var_src, var_sender_79)
    let (local _2_82 : Uint256) = is_zero(_1_81)
    __warp_block_7_if(_2_82, var_sender_79, var_src, var_wad_78)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _18 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_src)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _19 : Uint256) = s_load(_18)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _20 : Uint256) = cleanup_from_storage_uint256(_19)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _21 : Uint256) = checked_sub_uint256(_20, var_wad_78)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256(_18, _21)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _22 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_dst)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _23 : Uint256) = s_load(_22)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _24 : Uint256) = cleanup_from_storage_uint256(_23)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _25 : Uint256) = u256_add(_24, var_wad_78)
    update_storage_value_offsett_uint256_to_uint256(_22, _25)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local var_80 : Uint256 = Uint256(low=1, high=0)
    return (var_80)
end

@external
func fun_transferFrom_external{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_src_low, var_src_high, var_dst_low, var_dst_high, var_wad_78_low, var_wad_78_high,
        var_sender_79_low, var_sender_79_high) -> (var_80_low, var_80_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var_80) = fun_transferFrom{memory_dict=memory_dict, msize=msize}(
        Uint256(var_src_low, var_src_high),
        Uint256(var_dst_low, var_dst_high),
        Uint256(var_wad_78_low, var_wad_78_high),
        Uint256(var_sender_79_low, var_sender_79_high))
    return (var_80.low, var_80.high)
end

func fun_withdraw{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_wad_89 : Uint256, var_sender_90 : Uint256) -> ():
    alloc_locals
    let (
        local _1_91 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_sender_90)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_92 : Uint256) = read_from_storage_split_dynamic_uint256(_1_91)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _3_93 : Uint256) = is_lt(_2_92, var_wad_89)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _4_94 : Uint256) = is_zero(_3_93)
    require_helper(_4_94)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _5_95 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_sender_90)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _6_96 : Uint256) = s_load(_5_95)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _7_97 : Uint256) = cleanup_from_storage_uint256(_6_96)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _8_98 : Uint256) = checked_sub_uint256(_7_97, var_wad_89)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256(_5_95, _8_98)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local expr_component : Uint256, local expr_component_1 : Uint256) = fun_deposit(
        var_sender_90, var_wad_89)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

@external
func fun_withdraw_external{range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_wad_89_low, var_wad_89_high, var_sender_90_low, var_sender_90_high) -> ():
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    fun_withdraw{memory_dict=memory_dict, msize=msize}(
        Uint256(var_wad_89_low, var_wad_89_high), Uint256(var_sender_90_low, var_sender_90_high))
    return ()
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_579{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_120 : Uint256) -> (dataSlot_121 : Uint256):
    alloc_locals
    local _1_122 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=_1_122.low, value=key_120)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_123 : Uint256 = Uint256(low=2, high=0)
    local _3_124 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=_3_124.low, value=_2_123)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_125 : Uint256 = Uint256(low=64, high=0)
    local _5_126 : Uint256 = _1_122
    let (local dataSlot_121 : Uint256) = sha(_1_122.low, _4_125.low)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_121)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_100 : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    local _1_101 : Uint256 = Uint256(low=0, high=0)
    mstore_(offset=_1_101.low, value=key_100)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_102 : Uint256 = Uint256(low=3, high=0)
    local _3_103 : Uint256 = Uint256(low=32, high=0)
    mstore_(offset=_3_103.low, value=_2_102)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_104 : Uint256 = Uint256(low=64, high=0)
    local _5_105 : Uint256 = _1_101
    let (local dataSlot : Uint256) = sha(_1_101.low, _4_104.low)
    local range_check_ptr = range_check_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot)
end

