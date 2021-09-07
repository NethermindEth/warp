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
    return fun_transferFrom{msize=msize, memory_dict=memory_dict}(
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

    let (local _1_9 : Uint256) = is_eq(var_src, var_sender)

    let (local _2_10 : Uint256) = is_zero(_1_9)

    __warp_block_1_if(_2_10, var_sender, var_src, var_wad)
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_397{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(key : Uint256) -> (dataSlot_17 : Uint256):
    alloc_locals
    local _1_18 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_18.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_18.low, value=key)
    local memory_dict : DictAccess* = memory_dict
    local _2_19 : Uint256 = _1_18
    local _3_20 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_20.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_20.low, value=_1_18)
    local memory_dict : DictAccess* = memory_dict
    local _4_21 : Uint256 = Uint256(low=64, high=0)
    local _5_22 : Uint256 = _1_18

    let (local dataSlot_17 : Uint256) = sha(_1_18.low, _4_21.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_17)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(slot : Uint256, key_23 : Uint256) -> (
        dataSlot_24 : Uint256):
    alloc_locals
    local _1_25 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _1_25.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_1_25.low, value=key_23)
    local memory_dict : DictAccess* = memory_dict
    local _2_26 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _2_26.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_2_26.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local _3_27 : Uint256 = Uint256(low=64, high=0)
    local _4_28 : Uint256 = _1_25

    let (local dataSlot_24 : Uint256) = sha(_1_25.low, _3_27.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    return (dataSlot_24)
end

func __warp_block_0_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_4 : Uint256) -> ():
    alloc_locals
    if _4.low + _4.high != 0:
        __warp_block_2()
        return ()
    else:
        return ()
    end
end

func __warp_block_1_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        _2_10 : Uint256, var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> ():
    alloc_locals
    if _2_10.low + _2_10.high != 0:
        __warp_block_3(var_sender, var_src, var_wad)
        return ()
    else:
        return ()
    end
end

func __warp_block_3{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(
        var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> ():
    alloc_locals
    local _3_11 : Uint256 = Uint256(low=0, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_11.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_11.low, value=var_src)
    local memory_dict : DictAccess* = memory_dict
    local _4_12 : Uint256 = Uint256(low=32, high=0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _4_12.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_4_12.low, value=_3_11)
    local memory_dict : DictAccess* = memory_dict
    local _5_13 : Uint256 = Uint256(low=64, high=0)

    let (local dataSlot : Uint256) = sha(_3_11.low, _5_13.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _3_11.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_3_11.low, value=var_sender)
    local memory_dict : DictAccess* = memory_dict
    local _6_14 : Uint256 = _4_12
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, _4_12.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize

    mstore(offset=_4_12.low, value=dataSlot)
    local memory_dict : DictAccess* = memory_dict
    local _7_15 : Uint256 = _5_13

    let (local dataSlot_1 : Uint256) = sha(_3_11.low, _5_13.low)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict

    let (local _8_16 : Uint256) = s_load(dataSlot_1)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr

    let (local _9 : Uint256) = is_lt(_8_16, var_wad)
    local memory_dict : DictAccess* = memory_dict
    __warp_block_4_if(_3_11, _9)

    let (local _14 : Uint256) = uint256_sub(_8_16, var_wad)

    s_store(key=dataSlot_1, value=_14)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_4_if{
        range_check_ptr, pedersen_ptr : HashBuiltin*, storage_ptr : Storage*,
        memory_dict : DictAccess*, msize}(_3_11 : Uint256, _9 : Uint256) -> ():
    alloc_locals
    if _9.low + _9.high != 0:
        __warp_block_5(_3_11)
        return ()
    else:
        return ()
    end
end

