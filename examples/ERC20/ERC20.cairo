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
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_sub)
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

func fun_approve{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_guy_low, var_guy_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var_low, var_high):
    alloc_locals
    local var_guy : Uint256 = Uint256(var_guy_low, var_guy_high)
    local var_wad : Uint256 = Uint256(var_wad_low, var_wad_high)
    local var_sender : Uint256 = Uint256(var_sender_low, var_sender_high)

    let (
        local _1_70 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570(
        var_sender)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _2_71 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _1_70, var_guy)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256(_2_71, var_wad)
    local var : Uint256 = Uint256(low=1, high=0)

    return (var.low, var.high)
end

@external
func fun_approve_external{range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_guy_low, var_guy_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var_low, var_high):
    alloc_locals
    let (local memory_dict : DictAccess*) = default_dict_new(0)
    tempvar msize = 0
    let (var_low, var_high) = fun_approve{
        range_check_ptr=range_check_ptr,
        pedersen_ptr=pedersen_ptr,
        storage_ptr=storage_ptr,
        memory_dict=memory_dict,
        msize=msize}(
        var_guy_low, var_guy_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high)
    return (var_low, var_high)
end

func fun_deposit{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_sender_72_low, var_sender_72_high, var_value_low, var_value_high) -> (
        var_73_low, var_73_high, var__low, var__high):
    alloc_locals
    local var_sender_72 : Uint256 = Uint256(var_sender_72_low, var_sender_72_high)
    local var_value : Uint256 = Uint256(var_value_low, var_value_high)

    let (
        local _1_74 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_sender_72)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    let (local _2_75 : Uint256) = s_load(_1_74)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_76 : Uint256) = cleanup_from_storage_uint256(_2_75)
    let (local _4_77 : Uint256) = u256_add(_3_76, var_value)
    update_storage_value_offsett_uint256_to_uint256(_1_74, _4_77)
    local var_73 : Uint256 = Uint256(low=21, high=0)
    local var_ : Uint256 = Uint256(low=12, high=0)

    return (var_73.low, var_73.high, var_.low, var_.high)
end

@external
func fun_deposit_external{range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_sender_72_low, var_sender_72_high, var_value_low, var_value_high) -> (
        var_73_low, var_73_high, var__low, var__high):
    alloc_locals
    let (local memory_dict : DictAccess*) = default_dict_new(0)
    tempvar msize = 0
    let (var_73_low, var_73_high, var__low, var__high) = fun_deposit{
        range_check_ptr=range_check_ptr,
        pedersen_ptr=pedersen_ptr,
        storage_ptr=storage_ptr,
        memory_dict=memory_dict,
        msize=msize}(var_sender_72_low, var_sender_72_high, var_value_low, var_value_high)
    return (var_73_low, var_73_high, var__low, var__high)
end

func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_src_low, var_src_high, var_dst_low, var_dst_high, var_wad_78_low, var_wad_78_high,
        var_sender_79_low, var_sender_79_high) -> (var_80_low, var_80_high):
    alloc_locals
    local var_src : Uint256 = Uint256(var_src_low, var_src_high)
    local var_dst : Uint256 = Uint256(var_dst_low, var_dst_high)
    local var_wad_78 : Uint256 = Uint256(var_wad_78_low, var_wad_78_high)
    local var_sender_79 : Uint256 = Uint256(var_sender_79_low, var_sender_79_high)

    let (local _1_81 : Uint256) = is_eq(var_src, var_sender_79)

    let (local _2_82 : Uint256) = is_zero(_1_81)

    if _2_82.low + _2_82.high != 0:
        __warp_block_0(var_sender_79, var_src, var_wad_78)

        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar storage_ptr : Storage* = storage_ptr
        tempvar msize = msize
        tempvar memory_dict : DictAccess* = memory_dict
    else:
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar storage_ptr : Storage* = storage_ptr
        tempvar msize = msize
        tempvar memory_dict : DictAccess* = memory_dict
    end
    let (
        local _18 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_src)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    let (local _19 : Uint256) = s_load(_18)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _20 : Uint256) = cleanup_from_storage_uint256(_19)
    let (local _21 : Uint256) = uint256_sub(_20, var_wad_78)
    update_storage_value_offsett_uint256_to_uint256(_18, _21)
    let (
        local _22 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_dst)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    let (local _23 : Uint256) = s_load(_22)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _24 : Uint256) = cleanup_from_storage_uint256(_23)
    let (local _25 : Uint256) = u256_add(_24, var_wad_78)
    update_storage_value_offsett_uint256_to_uint256(_22, _25)
    local var_80 : Uint256 = Uint256(low=1, high=0)

    return (var_80.low, var_80.high)
end

@external
func fun_transferFrom_external{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_src_low, var_src_high, var_dst_low, var_dst_high, var_wad_78_low, var_wad_78_high,
        var_sender_79_low, var_sender_79_high) -> (var_80_low, var_80_high):
    alloc_locals
    let (local memory_dict : DictAccess*) = default_dict_new(0)
    tempvar msize = 0
    let (var_80_low, var_80_high) = fun_transferFrom{
        range_check_ptr=range_check_ptr,
        pedersen_ptr=pedersen_ptr,
        storage_ptr=storage_ptr,
        memory_dict=memory_dict,
        msize=msize}(
        var_src_low,
        var_src_high,
        var_dst_low,
        var_dst_high,
        var_wad_78_low,
        var_wad_78_high,
        var_sender_79_low,
        var_sender_79_high)
    return (var_80_low, var_80_high)
end

func fun_withdraw{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_wad_89_low, var_wad_89_high, var_sender_90_low, var_sender_90_high) -> ():
    alloc_locals
    local var_wad_89 : Uint256 = Uint256(var_wad_89_low, var_wad_89_high)
    local var_sender_90 : Uint256 = Uint256(var_sender_90_low, var_sender_90_high)

    let (
        local _1_91 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_sender_90)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_92 : Uint256) = read_from_storage_split_dynamic_uint256(_1_91)

    let (local _3_93 : Uint256) = is_lt(_2_92, var_wad_89)
    local memory_dict : DictAccess* = memory_dict

    let (local _4_94 : Uint256) = is_zero(_3_93)

    require_helper(_4_94)
    let (
        local _5_95 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_sender_90)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    let (local _6_96 : Uint256) = s_load(_5_95)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _7_97 : Uint256) = cleanup_from_storage_uint256(_6_96)
    let (local _8_98 : Uint256) = uint256_sub(_7_97, var_wad_89)
    update_storage_value_offsett_uint256_to_uint256(_5_95, _8_98)
    let (local expr_component_low, local expr_component_high, local expr_component_1_low,
        local expr_component_1_high) = fun_deposit(
        var_sender_90_low, var_sender_90_high, var_wad_89_low, var_wad_89_high)
    local expr_component : Uint256 = Uint256(expr_component_low, expr_component_high)
    local expr_component_1 : Uint256 = Uint256(expr_component_1_low, expr_component_1_high)

    return ()
end

@external
func fun_withdraw_external{range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_wad_89_low, var_wad_89_high, var_sender_90_low, var_sender_90_high) -> ():
    alloc_locals
    let (local memory_dict : DictAccess*) = default_dict_new(0)
    tempvar msize = 0
    fun_withdraw{
        range_check_ptr=range_check_ptr,
        pedersen_ptr=pedersen_ptr,
        storage_ptr=storage_ptr,
        memory_dict=memory_dict,
        msize=msize}(var_wad_89_low, var_wad_89_high, var_sender_90_low, var_sender_90_high)
    return ()
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_567{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_100 : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    local _1_101 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_101.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_101.low, value=key_100)
    local memory_dict : DictAccess* = memory_dict
    local _2_102 : Uint256 = Uint256(low=3, high=0)
    local _3_103 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_103.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_103.low, value=_2_102)
    local memory_dict : DictAccess* = memory_dict
    local _4_104 : Uint256 = Uint256(low=64, high=0)
    local _5_105 : Uint256 = _1_101

    let (local dataSlot : Uint256) = sha(_1_101.low, _4_104.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_106 : Uint256) -> (dataSlot_107 : Uint256):
    alloc_locals
    local _1_108 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_108.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_108.low, value=key_106)
    local memory_dict : DictAccess* = memory_dict
    local _2_109 : Uint256 = Uint256(low=3, high=0)
    local _3_110 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_110.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_110.low, value=_2_109)
    local memory_dict : DictAccess* = memory_dict
    local _4_111 : Uint256 = Uint256(low=64, high=0)
    local _5_112 : Uint256 = _1_108

    let (local dataSlot_107 : Uint256) = sha(_1_108.low, _4_111.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_107)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_113 : Uint256) -> (dataSlot_114 : Uint256):
    alloc_locals
    local _1_115 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_115.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_115.low, value=key_113)
    local memory_dict : DictAccess* = memory_dict
    local _2_116 : Uint256 = Uint256(low=2, high=0)
    local _3_117 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_117.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_117.low, value=_2_116)
    local memory_dict : DictAccess* = memory_dict
    local _4_118 : Uint256 = Uint256(low=64, high=0)
    local _5_119 : Uint256 = _1_115

    let (local dataSlot_114 : Uint256) = sha(_1_115.low, _4_118.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_114)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_579{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_120 : Uint256) -> (dataSlot_121 : Uint256):
    alloc_locals
    local _1_122 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_122.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_122.low, value=key_120)
    local memory_dict : DictAccess* = memory_dict
    local _2_123 : Uint256 = Uint256(low=2, high=0)
    local _3_124 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_124.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_124.low, value=_2_123)
    local memory_dict : DictAccess* = memory_dict
    local _4_125 : Uint256 = Uint256(low=64, high=0)
    local _5_126 : Uint256 = _1_122

    let (local dataSlot_121 : Uint256) = sha(_1_122.low, _4_125.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_121)
end
func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_127 : Uint256) -> (
        dataSlot_128 : Uint256):
    alloc_locals
    local _1_129 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_129.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_129.low, value=key_127)
    local memory_dict : DictAccess* = memory_dict
    local _2_130 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_130.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_130.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local _3_131 : Uint256 = Uint256(low=64, high=0)
    local _4_132 : Uint256 = _1_129

    let (local dataSlot_128 : Uint256) = sha(_1_129.low, _3_131.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    return (dataSlot_128)
end
func require_helper{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(condition : Uint256) -> ():
    alloc_locals

    let (local _1_142 : Uint256) = is_zero(condition)

    if _1_142.low + _1_142.high != 0:
        __warp_block_1()

        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar storage_ptr : Storage* = storage_ptr
        tempvar msize = msize
        tempvar memory_dict : DictAccess* = memory_dict
    else:
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        tempvar storage_ptr : Storage* = storage_ptr
        tempvar msize = msize
        tempvar memory_dict : DictAccess* = memory_dict
    end

    return ()
end
func revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _1_145 : Uint256 = Uint256(low=0, high=0)
    local _2_146 : Uint256 = _1_145
    assert 0 = 1

    return ()
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
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_151 : Uint256) = update_byte_slice_shift(_1_150, value_149)
    s_store(key=slot_148, value=_2_151)

    return ()
end
func __warp_block_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_sender_79 : Uint256, var_src : Uint256, var_wad_78 : Uint256) -> ():
    alloc_locals
    let (
        local _3_83 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570(
        var_src)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _4_84 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _3_83, var_sender_79)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _5_85 : Uint256) = read_from_storage_split_dynamic_uint256(_4_84)

    let (local _6_86 : Uint256) = is_lt(_5_85, var_wad_78)
    local memory_dict : DictAccess* = memory_dict

    let (local _7_87 : Uint256) = is_zero(_6_86)

    require_helper(_7_87)
    let (
        local _8_88 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571(
        var_src)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _9 : Uint256) = read_from_storage_split_dynamic_uint256(_8_88)
    let (local _10 : Uint256) = cleanup_from_storage_uint256(_9)

    let (local _11 : Uint256) = is_lt(_10, var_wad_78)
    local memory_dict : DictAccess* = memory_dict

    let (local _12 : Uint256) = is_zero(_11)

    require_helper(_12)
    let (
        local _13 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570(
        var_src)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _14 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _13, var_sender_79)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    let (local _15 : Uint256) = s_load(_14)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _16 : Uint256) = cleanup_from_storage_uint256(_15)
    let (local _17 : Uint256) = uint256_sub(_16, var_wad_78)
    update_storage_value_offsett_uint256_to_uint256(_14, _17)

    return ()
end

