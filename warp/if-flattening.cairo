%lang starknet
%builtins pedersen range_check

from evm.memory import mstore
from evm.sha3 import sha
from evm.uint256 import is_eq, is_zero
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_sub
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

func extract_from_storage_value_dynamict_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_value : Uint256) -> (value_13 : Uint256):
    alloc_locals
    local value_13 : Uint256 = slot_value
    return (value_13)
end

func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_src : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    local var_res : Uint256 = Uint256(low=0, high=0)

    let (local _1_14 : Uint256) = is_eq(var_src, var_sender)

    let (local _2_15 : Uint256) = is_zero(_1_14)

    let (var_res) = __warp_block_0(_2_15, var_res, var_sender, var_src, var_wad)

    local var : Uint256 = var_res
    return (var)
end

@external
func fun_transferFrom_external{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*}(
        var_src_low, var_src_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var_low, var_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var) = fun_transferFrom{memory_dict=memory_dict, msize=msize}(
        Uint256(var_src_low, var_src_high),
        Uint256(var_wad_low, var_wad_high),
        Uint256(var_sender_low, var_sender_high))
    return (var.low, var.high)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_278{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    local _1_21 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_21.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_21.low, value=key)
    local memory_dict : DictAccess* = memory_dict
    local _2_22 : Uint256 = _1_21
    local _3_23 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_23.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_23.low, value=_1_21)
    local memory_dict : DictAccess* = memory_dict
    local _4_24 : Uint256 = Uint256(low=64, high=0)
    local _5_25 : Uint256 = _1_21

    let (local dataSlot : Uint256) = sha(_1_21.low, _4_24.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_280{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key_26 : Uint256) -> (dataSlot_27 : Uint256):
    alloc_locals
    local _1_28 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_28.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_28.low, value=key_26)
    local memory_dict : DictAccess* = memory_dict
    local _2_29 : Uint256 = _1_28
    local _3_30 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_30.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_30.low, value=_1_28)
    local memory_dict : DictAccess* = memory_dict
    local _4_31 : Uint256 = Uint256(low=64, high=0)
    local _5_32 : Uint256 = _1_28

    let (local dataSlot_27 : Uint256) = sha(_1_28.low, _4_31.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_27)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_33 : Uint256) -> (
        dataSlot_34 : Uint256):
    alloc_locals
    local _1_35 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_35.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_35.low, value=key_33)
    local memory_dict : DictAccess* = memory_dict
    local _2_36 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_36.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_36.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local _3_37 : Uint256 = Uint256(low=64, high=0)
    local _4_38 : Uint256 = _1_35

    let (local dataSlot_34 : Uint256) = sha(_1_35.low, _3_37.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_34)
end

func read_from_storage_split_dynamic_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_45 : Uint256) -> (value_46 : Uint256):
    alloc_locals

    let (local _1_47 : Uint256) = s_load(slot_45)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (value_46) = extract_from_storage_value_dynamict_uint256(_1_47)

    return (value_46)
end

func revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}() -> ():
    alloc_locals
    local _1_48 : Uint256 = Uint256(low=0, high=0)
    local _2_49 : Uint256 = _1_48
    assert 0 = 1
    return ()
end

func update_byte_slice_shift{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(value_50 : Uint256, toInsert : Uint256) -> (
        result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot_51 : Uint256, value_52 : Uint256) -> ():
    alloc_locals

    let (local _1_53 : Uint256) = s_load(slot_51)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _2_54 : Uint256) = update_byte_slice_shift(_1_53, value_52)
    s_store(key=slot_51, value=_2_54)
    return ()
end

func __warp_block_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        _2_15 : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    local match_var : Uint256 = _2_15
    let (var_res) = __warp_block_1(match_var, var_res, var_sender, var_src, var_wad)

    return (var_res)
end

func __warp_block_1{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        match_var : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals

    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))

    let (var_res) = __warp_block_2_if(__warp_subexpr_0, var_res, var_sender, var_src, var_wad)

    return (var_res)
end

func __warp_block_2_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        __warp_subexpr_0 : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local var_res : Uint256 = Uint256(low=2, high=0)
        return (var_res)
    else:
        let (var_res) = __warp_block_3(var_res, var_sender, var_src, var_wad)

        return (var_res)
    end
end

func __warp_block_3{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_res : Uint256, var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    let (
        local _3_16 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_280(
        var_src)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _4_17 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256(
        _3_16, var_sender)
    local range_check_ptr = range_check_ptr
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    let (local _5_18 : Uint256) = s_load(_4_17)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _6_19 : Uint256) = extract_from_storage_value_dynamict_uint256(_5_18)
    let (local _7_20 : Uint256) = uint256_sub(_6_19, var_wad)
    update_storage_value_offsett_uint256_to_uint256(_4_17, _7_20)
    local var_res : Uint256 = Uint256(low=1, high=0)
    return (var_res)
end

