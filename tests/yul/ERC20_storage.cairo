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
    let (local _1_55 : Uint256) = uint256_not(y)
    local range_check_ptr = range_check_ptr
    let (local _2_56 : Uint256) = is_gt(x, _1_55)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_2_56)
    let (local sum : Uint256) = u256_add(x, y)
    local range_check_ptr = range_check_ptr
    return (sum)
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
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_ : Uint256) = fun_approve(
            Uint256(var_guy_low, var_guy_high),
            Uint256(var_wad_low, var_wad_high),
            Uint256(var_sender_low, var_sender_high))
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
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
    let (local _4_69 : Uint256) = checked_add_uint256{range_check_ptr=range_check_ptr}(
        _3_68, var_value)
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
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_deposit(
            Uint256(var_sender_65_low, var_sender_65_high), Uint256(var_value_low, var_value_high))
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
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
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_get_balance(Uint256(var_src_low, var_src_high))
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var.low, var.high)
end

func require_helper{range_check_ptr}(condition : Uint256) -> ():
    alloc_locals
    let (local _1_136 : Uint256) = is_zero(condition)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_136)
    return ()
end

func __warp_block_1{
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
        __warp_block_1{
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
    let (local _25 : Uint256) = checked_add_uint256{range_check_ptr=range_check_ptr}(
        _24, var_wad_72)
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
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var_74 : Uint256) = fun_transferFrom(
            Uint256(var_src_71_low, var_src_71_high),
            Uint256(var_dst_low, var_dst_high),
            Uint256(var_wad_72_low, var_wad_72_high),
            Uint256(var_sender_73_low, var_sender_73_high))
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
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
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        fun_withdraw(
            Uint256(var_wad_83_low, var_wad_83_high),
            Uint256(var_sender_84_low, var_sender_84_high))
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return ()
end
