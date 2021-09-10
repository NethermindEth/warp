%lang starknet
%builtins pedersen range_check

from evm.memory import mstore
from evm.sha3 import sha
from evm.uint256 import is_eq, is_lt, is_zero
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_shl, uint256_sub
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

@external
func fun_transferFrom_external(
        var_src_low, var_src_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var_low, var_high):
    alloc_locals
    let (local memory_dict : DictAccess*) = default_dict_new(0)
    tempvar msize = 0
    return fun_transferFrom{memory_dict=memory_dict, msize=msize}(
        var_src_low, var_src_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high)
end

func fun_transferFrom{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_src_low, var_src_high, var_wad_low, var_wad_high, var_sender_low, var_sender_high) -> (
        var_low, var_high):
    alloc_locals
    local var_src : Uint256 = Uint256(var_src_low, var_src_high)
    local var_wad : Uint256 = Uint256(var_wad_low, var_wad_high)
    local var_sender : Uint256 = Uint256(var_sender_low, var_sender_high)
    local var_res : Uint256 = Uint256(low=0, high=0)

    let (local _1_3 : Uint256) = is_eq(var_src, var_sender)

    let (local _2_4 : Uint256) = is_zero(_1_3)

    let (var_res) = __warp_block_0(_2_4, var_res, var_sender, var_src, var_wad)

    local var : Uint256 = var_res
    return (var)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_406{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key : Uint256) -> (dataSlot_11 : Uint256):
    alloc_locals
    local _1_12 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_12.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_12.low, value=key)
    local memory_dict : DictAccess* = memory_dict
    local _2_13 : Uint256 = _1_12
    local _3_14 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_14.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_14.low, value=_1_12)
    local memory_dict : DictAccess* = memory_dict
    local _4_15 : Uint256 = Uint256(low=64, high=0)
    local _5_16 : Uint256 = _1_12

    let (local dataSlot_11 : Uint256) = sha(_1_12.low, _4_15.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_11)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_17 : Uint256) -> (
        dataSlot_18 : Uint256):
    alloc_locals
    local _1_19 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_19.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_19.low, value=key_17)
    local memory_dict : DictAccess* = memory_dict
    local _2_20 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_20.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_20.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local _3_21 : Uint256 = Uint256(low=64, high=0)
    local _4_22 : Uint256 = _1_19

    let (local dataSlot_18 : Uint256) = sha(_1_19.low, _3_21.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_18)
end

func __warp_block_0{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        _2_4 : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    local match_var : Uint256 = _2_4
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
    local _3_5 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_5.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_5.low, value=var_src)
    local memory_dict : DictAccess* = memory_dict
    local _4_6 : Uint256 = _3_5
    local _5_7 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _5_7.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_5_7.low, value=_3_5)
    local memory_dict : DictAccess* = memory_dict
    local _6_8 : Uint256 = Uint256(low=64, high=0)
    local _7_9 : Uint256 = _3_5

    let (local dataSlot : Uint256) = sha(_3_5.low, _6_8.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    local _8_10 : Uint256 = _3_5
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_5.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_5.low, value=var_sender)
    local memory_dict : DictAccess* = memory_dict
    local _9 : Uint256 = _5_7
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _5_7.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_5_7.low, value=dataSlot)
    local memory_dict : DictAccess* = memory_dict
    local _10 : Uint256 = _6_8
    local _11 : Uint256 = _3_5

    let (local dataSlot_1 : Uint256) = sha(_3_5.low, _6_8.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _12 : Uint256) = s_load(dataSlot_1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _13 : Uint256) = is_lt(_12, var_wad)
    local memory_dict : DictAccess* = memory_dict
    if _13.low + _13.high != 0:
        let (local _14 : Uint256) = uint256_shl(
            Uint256(low=224, high=0), Uint256(low=1313373041, high=0))

        local _15 : Uint256 = _3_5
        let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_5.low, 32)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize

        mstore(offset=_3_5.low, value=_14)
        local memory_dict : DictAccess* = memory_dict
        local _16 : Uint256 = Uint256(low=17, high=0)
        local _17 : Uint256 = Uint256(low=4, high=0)
        let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _17.low, 32)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize

        mstore(offset=_17.low, value=_16)
        local memory_dict : DictAccess* = memory_dict
        local _18 : Uint256 = Uint256(low=36, high=0)
        local _19 : Uint256 = _3_5
        assert 0 = 1
    end

    let (local _20 : Uint256) = uint256_sub(_12, var_wad)

    s_store(key=dataSlot_1, value=_20)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_res : Uint256 = Uint256(low=1, high=0)
    return (var_res)
end

