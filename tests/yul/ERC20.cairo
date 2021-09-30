%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.memory import mstore_
from evm.sha3 import sha
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not, uint256_sub
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

func checked_add_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_62 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_63 : Uint256) = is_gt(x, _1_62)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_2_63)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func checked_sub_uint256{range_check_ptr}(x_64 : Uint256, y_65 : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_66 : Uint256) = is_lt(x_64, y_65)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_66)
    let (local diff : Uint256) = uint256_sub(x_64, y_65)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func cleanup_from_storage_uint256(value_67 : Uint256) -> (cleaned : Uint256):
    alloc_locals
    local cleaned : Uint256 = value_67
    return (cleaned)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_106 : Uint256) -> (
        dataSlot_107 : Uint256):
    alloc_locals
    local _1_108 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_108.low, value=key_106)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_109 : Uint256 = Uint256(low=3, high=0)
    local _3_110 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_110.low, value=_2_109)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_111 : Uint256 = Uint256(low=64, high=0)
    local _5_112 : Uint256 = _1_108
    let (local dataSlot_107 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_108.low, _4_111.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_107)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict : DictAccess*, msize, range_check_ptr}(slot : Uint256, key_127 : Uint256) -> (
        dataSlot_128 : Uint256):
    alloc_locals
    local _1_129 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_129.low, value=key_127)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_130 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_130.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_131 : Uint256 = Uint256(low=64, high=0)
    local _4_132 : Uint256 = _1_129
    let (local dataSlot_128 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_129.low, _3_131.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_128)
end

func update_byte_slice_shift(value_147 : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr : HashBuiltin*, storage_ptr : Storage*, range_check_ptr}(
        slot_148 : Uint256, value_149 : Uint256) -> ():
    alloc_locals
    let (local _1_150 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        slot_148)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _2_151 : Uint256) = update_byte_slice_shift(_1_150, value_149)
    s_store{storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        key=slot_148, value=_2_151)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return ()
end

func fun_approve{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        range_check_ptr}(var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (
        var : Uint256):
    alloc_locals
    let (
        local _1_70 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570{
        memory_dict=memory_dict, msize=msize}(var_sender)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _2_71 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_1_70, var_guy)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_2_71, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_approve_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_guy : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var_low, var_high):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_approve(var_guy, var_wad, var_sender)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var.low, var.high)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_113 : Uint256) -> (
        dataSlot_114 : Uint256):
    alloc_locals
    local _1_115 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_115.low, value=key_113)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_116 : Uint256 = Uint256(low=2, high=0)
    local _3_117 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_117.low, value=_2_116)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_118 : Uint256 = Uint256(low=64, high=0)
    local _5_119 : Uint256 = _1_115
    let (local dataSlot_114 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(
        _1_115.low, _4_118.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_114)
end

func fun_deposit{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_sender_72 : Uint256, var_value : Uint256) -> (
        var_73 : Uint256, var_ : Uint256):
    alloc_locals
    let (
        local _1_74 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict=memory_dict, msize=msize}(var_sender_72)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_75 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_1_74)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _3_76 : Uint256) = cleanup_from_storage_uint256(_2_75)
    let (local _4_77 : Uint256) = checked_add_uint256{range_check_ptr=range_check_ptr}(
        _3_76, var_value)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_1_74, _4_77)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_73 : Uint256 = Uint256(low=21, high=0)
    local var_ : Uint256 = Uint256(low=12, high=0)
    return (var_73, var_)
end

@external
func fun_deposit_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_sender_72 : Uint256, var_value : Uint256) -> (
        var_73_low, var_73_high, var__low, var__high):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_73 : Uint256, local var_ : Uint256) = fun_deposit(var_sender_72, var_value)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_73.low, var_73.high, var_.low, var_.high)
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, storage_ptr : Storage*, range_check_ptr}(
        slot_139 : Uint256) -> (value_140 : Uint256):
    alloc_locals
    let (local _1_141 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        slot_139)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local value_140 : Uint256) = cleanup_from_storage_uint256(_1_141)
    return (value_140)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_142 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_142)
    return ()
end

func __warp_block_1{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_sender_79 : Uint256, var_src : Uint256, var_wad_78 : Uint256) -> ():
    alloc_locals
    let (
        local _3_83 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570{
        memory_dict=memory_dict, msize=msize}(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _4_84 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_3_83, var_sender_79)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _5_85 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_4_84)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _6_86 : Uint256) = is_lt(_5_85, var_wad_78)
    local range_check_ptr = range_check_ptr
    let (local _7_87 : Uint256) = is_zero(_6_86)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_7_87)
    local range_check_ptr = range_check_ptr
    let (
        local _8_88 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict=memory_dict, msize=msize}(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _9 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_8_88)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _10 : Uint256) = cleanup_from_storage_uint256(_9)
    let (local _11 : Uint256) = is_lt(_10, var_wad_78)
    local range_check_ptr = range_check_ptr
    let (local _12 : Uint256) = is_zero(_11)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_12)
    local range_check_ptr = range_check_ptr
    let (
        local _13 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_570{
        memory_dict=memory_dict, msize=msize}(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _14 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_13, var_sender_79)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _15 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_14)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _16 : Uint256) = cleanup_from_storage_uint256(_15)
    let (local _17 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _16, var_wad_78)
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
        _2_82 : Uint256, var_sender_79 : Uint256, var_src : Uint256, var_wad_78 : Uint256) -> ():
    alloc_locals
    if _2_82.low + _2_82.high != 0:
        __warp_block_1{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(var_sender_79, var_src, var_wad_78)
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
        var_src : Uint256, var_dst : Uint256, var_wad_78 : Uint256, var_sender_79 : Uint256) -> (
        var_80 : Uint256):
    alloc_locals
    let (local _1_81 : Uint256) = is_eq(var_src, var_sender_79)
    local range_check_ptr = range_check_ptr
    let (local _2_82 : Uint256) = is_zero(_1_81)
    local range_check_ptr = range_check_ptr
    __warp_block_0_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_82, var_sender_79, var_src, var_wad_78)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (
        local _18 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict=memory_dict, msize=msize}(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _19 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_18)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _20 : Uint256) = cleanup_from_storage_uint256(_19)
    let (local _21 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _20, var_wad_78)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_18, _21)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (
        local _22 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict=memory_dict, msize=msize}(var_dst)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _23 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_22)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _24 : Uint256) = cleanup_from_storage_uint256(_23)
    let (local _25 : Uint256) = checked_add_uint256{range_check_ptr=range_check_ptr}(
        _24, var_wad_78)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_22, _25)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_80 : Uint256 = Uint256(low=1, high=0)
    return (var_80)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256, var_dst : Uint256, var_wad_78 : Uint256, var_sender_79 : Uint256) -> (
        var_80_low, var_80_high):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_80 : Uint256) = fun_transferFrom(var_src, var_dst, var_wad_78, var_sender_79)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var_80.low, var_80.high)
end

func fun_withdraw{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_wad_89 : Uint256, var_sender_90 : Uint256) -> ():
    alloc_locals
    let (
        local _1_91 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict=memory_dict, msize=msize}(var_sender_90)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _2_92 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_1_91)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _3_93 : Uint256) = is_lt(_2_92, var_wad_89)
    local range_check_ptr = range_check_ptr
    let (local _4_94 : Uint256) = is_zero(_3_93)
    local range_check_ptr = range_check_ptr
    require_helper{range_check_ptr=range_check_ptr}(_4_94)
    local range_check_ptr = range_check_ptr
    let (
        local _5_95 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_571{
        memory_dict=memory_dict, msize=msize}(var_sender_90)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _6_96 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_5_95)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _7_97 : Uint256) = cleanup_from_storage_uint256(_6_96)
    let (local _8_98 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _7_97, var_wad_89)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_5_95, _8_98)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local expr_component : Uint256, local expr_component_1 : Uint256) = fun_deposit{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(var_sender_90, var_wad_89)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

@external
func fun_withdraw_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_wad_89 : Uint256, var_sender_90 : Uint256) -> ():
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(var_wad_89, var_sender_90)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end
