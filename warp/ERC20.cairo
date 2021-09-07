%lang starknet
%builtins pedersen range_check

from evm.memory import mstore
from evm.sha3 import sha
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_sub)
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

func cleanup_from_storage_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(value_60 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_60
    return (cleaned)
end
func extract_from_storage_value_dynamict_uint8{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_value : Uint256) -> (value_61 : Uint256):
    alloc_locals
    local _1_62 : Uint256 = Uint256(low=255, high=0)

    let (local value_61 : Uint256) = uint256_and(slot_value, _1_62)

    return (value_61)
end
func fun_approve{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_ : Uint256):
    alloc_locals
    let (
        local _1_63 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_543(
        var_sender)
    let (
        local _2_64 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _1_63, var_guy)
    update_storage_value_offsett_uint256_to_uint256(_2_64, var_wad)
    local var_ : Uint256 = Uint256(low=1, high=0)
    return (var_)
end
func fun_deposit{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_sender_65 : Uint256, var_value : Uint256) -> ():
    alloc_locals
    let (
        local _1_66 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544(
        var_sender_65)

    let (local _2_67 : Uint256) = s_load(_1_66)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_68 : Uint256) = cleanup_from_storage_uint256(_2_67)
    let (local _4_69 : Uint256) = u256_add(_3_68, var_value)
    update_storage_value_offsett_uint256_to_uint256(_1_66, _4_69)
    return ()
end
func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_src : Uint256, var_dst : Uint256, var_wad_70 : Uint256, var_sender_71 : Uint256) -> (
        var : Uint256):
    alloc_locals

    let (local _1_72 : Uint256) = is_eq(var_src, var_sender_71)

    let (local _2_73 : Uint256) = is_zero(_1_72)

    if _2_73.low + _2_73.high != 0:
        __warp_block_0(var_sender_71, var_src, var_wad_70)
    end
    let (
        local _18 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544(
        var_src)

    let (local _19 : Uint256) = s_load(_18)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _20 : Uint256) = cleanup_from_storage_uint256(_19)
    let (local _21 : Uint256) = uint256_sub(_20, var_wad_70)
    update_storage_value_offsett_uint256_to_uint256(_18, _21)
    let (
        local _22 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544(
        var_dst)

    let (local _23 : Uint256) = s_load(_22)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _24 : Uint256) = cleanup_from_storage_uint256(_23)
    let (local _25 : Uint256) = u256_add(_24, var_wad_70)
    update_storage_value_offsett_uint256_to_uint256(_22, _25)
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end
func fun_withdraw{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(var_wad_80 : Uint256, var_sender_81 : Uint256) -> ():
    alloc_locals
    let (
        local _1_82 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544(
        var_sender_81)
    let (local _2_83 : Uint256) = read_from_storage_split_dynamic_uint256(_1_82)

    let (local _3_84 : Uint256) = is_lt(_2_83, var_wad_80)

    local memory_dict : DictAccess* = memory_dict

    let (local _4_85 : Uint256) = is_zero(_3_84)

    require_helper(_4_85)
    let (
        local _5_86 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544(
        var_sender_81)

    let (local _6_87 : Uint256) = s_load(_5_86)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_88 : Uint256) = cleanup_from_storage_uint256(_6_87)
    let (local _8_89 : Uint256) = uint256_sub(_7_88, var_wad_80)
    update_storage_value_offsett_uint256_to_uint256(_5_86, _8_89)
    return ()
end
func getter_fun_balanceOf{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key : Uint256) -> (ret__warp_mangled : Uint256):
    alloc_locals
    let (
        local _1_90 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_552(
        key)
    let (local ret__warp_mangled : Uint256) = read_from_storage_split_dynamic_uint256(_1_90)
    return (ret__warp_mangled)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_540{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_91 : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    local _1_92 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_92.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_92.low, value=key_91)
    local memory_dict : DictAccess* = memory_dict
    local _2_93 : Uint256 = Uint256(low=3, high=0)
    local _3_94 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_94.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_94.low, value=_2_93)
    local memory_dict : DictAccess* = memory_dict
    local _4_95 : Uint256 = Uint256(low=64, high=0)
    local _5_96 : Uint256 = _1_92

    let (local dataSlot : Uint256) = sha(_1_92.low, _4_95.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_543{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_97 : Uint256) -> (dataSlot_98 : Uint256):
    alloc_locals
    local _1_99 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_99.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_99.low, value=key_97)
    local memory_dict : DictAccess* = memory_dict
    local _2_100 : Uint256 = Uint256(low=3, high=0)
    local _3_101 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_101.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_101.low, value=_2_100)
    local memory_dict : DictAccess* = memory_dict
    local _4_102 : Uint256 = Uint256(low=64, high=0)
    local _5_103 : Uint256 = _1_99

    let (local dataSlot_98 : Uint256) = sha(_1_99.low, _4_102.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_98)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_104 : Uint256) -> (dataSlot_105 : Uint256):
    alloc_locals
    local _1_106 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_106.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_106.low, value=key_104)
    local memory_dict : DictAccess* = memory_dict
    local _2_107 : Uint256 = Uint256(low=2, high=0)
    local _3_108 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_108.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_108.low, value=_2_107)
    local memory_dict : DictAccess* = memory_dict
    local _4_109 : Uint256 = Uint256(low=64, high=0)
    local _5_110 : Uint256 = _1_106

    let (local dataSlot_105 : Uint256) = sha(_1_106.low, _4_109.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_105)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_552{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_111 : Uint256) -> (dataSlot_112 : Uint256):
    alloc_locals
    local _1_113 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_113.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_113.low, value=key_111)
    local memory_dict : DictAccess* = memory_dict
    local _2_114 : Uint256 = Uint256(low=2, high=0)
    local _3_115 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_115.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_115.low, value=_2_114)
    local memory_dict : DictAccess* = memory_dict
    local _4_116 : Uint256 = Uint256(low=64, high=0)
    local _5_117 : Uint256 = _1_113

    let (local dataSlot_112 : Uint256) = sha(_1_113.low, _4_116.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_112)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_118 : Uint256) -> (
        dataSlot_119 : Uint256):
    alloc_locals
    local _1_120 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_120.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_120.low, value=key_118)
    local memory_dict : DictAccess* = memory_dict
    local _2_121 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_121.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_121.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local _3_122 : Uint256 = Uint256(low=64, high=0)
    local _4_123 : Uint256 = _1_120

    let (local dataSlot_119 : Uint256) = sha(_1_120.low, _3_122.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_119)
end
func panic_error_0x11{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals

    let (local _1_124 : Uint256) = uint256_shl(
        Uint256(low=224, high=0), Uint256(low=1313373041, high=0))

    local _2_125 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_125.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_125.low, value=_1_124)
    local memory_dict : DictAccess* = memory_dict
    local _3_126 : Uint256 = Uint256(low=17, high=0)
    local _4_127 : Uint256 = Uint256(low=4, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _4_127.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_4_127.low, value=_3_126)
    local memory_dict : DictAccess* = memory_dict
    local _5_128 : Uint256 = Uint256(low=36, high=0)
    local _6_129 : Uint256 = _2_125
    assert 0 = 1
    return ()
end
func read_from_storage_split_dynamic_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_130 : Uint256) -> (value_131 : Uint256):
    alloc_locals

    let (local _1_132 : Uint256) = s_load(slot_130)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local value_131 : Uint256) = cleanup_from_storage_uint256(_1_132)
    return (value_131)
end
func require_helper{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(condition : Uint256) -> ():
    alloc_locals

    let (local _1_133 : Uint256) = is_zero(condition)

    if _1_133.low + _1_133.high != 0:
        __warp_block_1()
    end
    return ()
end
func revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _1_136 : Uint256 = Uint256(low=0, high=0)
    local _2_137 : Uint256 = _1_136
    assert 0 = 1
    return ()
end
func update_byte_slice_shift{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(value_138 : Uint256, toInsert : Uint256) -> (
        result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end
func update_storage_value_offsett_uint256_to_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_139 : Uint256, value_140 : Uint256) -> ():
    alloc_locals

    let (local _1_141 : Uint256) = s_load(slot_139)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_142 : Uint256) = update_byte_slice_shift(_1_141, value_140)
    s_store(key=slot_139, value=_2_142)
    return ()
end
func __warp_block_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_sender_71 : Uint256, var_src : Uint256, var_wad_70 : Uint256) -> ():
    alloc_locals
    let (
        local _3_74 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_543(
        var_src)
    let (
        local _4_75 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _3_74, var_sender_71)
    let (local _5_76 : Uint256) = read_from_storage_split_dynamic_uint256(_4_75)

    let (local _6_77 : Uint256) = is_lt(_5_76, var_wad_70)

    local memory_dict : DictAccess* = memory_dict

    let (local _7_78 : Uint256) = is_zero(_6_77)

    require_helper(_7_78)
    let (
        local _8_79 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_544(
        var_src)
    let (local _9 : Uint256) = read_from_storage_split_dynamic_uint256(_8_79)
    let (local _10 : Uint256) = cleanup_from_storage_uint256(_9)

    let (local _11 : Uint256) = is_lt(_10, var_wad_70)

    local memory_dict : DictAccess* = memory_dict

    let (local _12 : Uint256) = is_zero(_11)

    require_helper(_12)
    let (
        local _13 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_543(
        var_src)
    let (
        local _14 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _13, var_sender_71)

    let (local _15 : Uint256) = s_load(_14)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _16 : Uint256) = cleanup_from_storage_uint256(_15)
    let (local _17 : Uint256) = uint256_sub(_16, var_wad_70)
    update_storage_value_offsett_uint256_to_uint256(_14, _17)
    return ()
end
func __warp_block_1{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _2_134 : Uint256 = Uint256(low=0, high=0)
    local _3_135 : Uint256 = _2_134
    assert 0 = 1
    return ()
end

