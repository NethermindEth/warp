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
    Uint256, uint256_eq, uint256_not, uint256_shr, uint256_sub)
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

func abi_decode_uint256t_uint256{range_check_ptr}(dataEnd : Uint256) -> (
        value0 : Uint256, value1 : Uint256):
    alloc_locals
    local _1 : Uint256 = Uint256(low=64, high=0)
    let (local _2 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3 : Uint256) = u256_add(dataEnd, _2)
    local range_check_ptr = range_check_ptr
    let (local _4 : Uint256) = slt(_3, _1)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4)
    local _5 : Uint256 = Uint256(low=4, high=0)
    local value0 : Uint256 = Uint256(31597865, 9284653)
    local _6 : Uint256 = Uint256(low=36, high=0)
    local value1 : Uint256 = Uint256(31597865, 9284653)
    return (value0, value1)
end

func abi_decode_uint256t_uint256t_uint256t_uint256{range_check_ptr}(dataEnd_1 : Uint256) -> (
        value0_2 : Uint256, value1_3 : Uint256, value2 : Uint256, value3 : Uint256):
    alloc_locals
    local _1_4 : Uint256 = Uint256(low=128, high=0)
    let (local _2_5 : Uint256) = uint256_not(Uint256(low=3, high=0))
    local range_check_ptr = range_check_ptr
    let (local _3_6 : Uint256) = u256_add(dataEnd_1, _2_5)
    local range_check_ptr = range_check_ptr
    let (local _4_7 : Uint256) = slt(_3_6, _1_4)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_4_7)
    local _5_8 : Uint256 = Uint256(low=4, high=0)
    local value0_2 : Uint256 = Uint256(31597865, 9284653)
    local _6_9 : Uint256 = Uint256(low=36, high=0)
    local value1_3 : Uint256 = Uint256(31597865, 9284653)
    local _7 : Uint256 = Uint256(low=68, high=0)
    local value2 : Uint256 = Uint256(31597865, 9284653)
    local _8 : Uint256 = Uint256(low=100, high=0)
    local value3 : Uint256 = Uint256(31597865, 9284653)
    return (value0_2, value1_3, value2, value3)
end

func abi_encode_uint256_to_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos.low, value=value)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_uint256{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_10 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_11 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart, _1_11)
    local range_check_ptr = range_check_ptr
    abi_encode_uint256_to_uint256{memory_dict=memory_dict, msize=msize}(value0_10, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (tail)
end

func checked_sub_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_12 : Uint256) = is_lt(x, y)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_12)
    let (local diff : Uint256) = uint256_sub(x, y)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func extract_from_storage_value_dynamict_uint256(slot_value : Uint256) -> (value_13 : Uint256):
    alloc_locals
    local value_13 : Uint256 = slot_value
    return (value_13)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_280{
        memory_dict : DictAccess*, msize, range_check_ptr}(key_26 : Uint256) -> (
        dataSlot_27 : Uint256):
    alloc_locals
    local _1_28 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_28.low, value=key_26)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_29 : Uint256 = _1_28
    local _3_30 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_30.low, value=_1_28)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_31 : Uint256 = Uint256(low=64, high=0)
    local _5_32 : Uint256 = _1_28
    let (local dataSlot_27 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(_1_28.low, _4_31.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_27)
end

func mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict : DictAccess*, msize, range_check_ptr}(slot : Uint256, key_33 : Uint256) -> (
        dataSlot_34 : Uint256):
    alloc_locals
    local _1_35 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_35.low, value=key_33)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_36 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_36.low, value=slot)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_37 : Uint256 = Uint256(low=64, high=0)
    local _4_38 : Uint256 = _1_35
    let (local dataSlot_34 : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(_1_35.low, _3_37.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot_34)
end

func update_byte_slice_shift(value_50 : Uint256, toInsert : Uint256) -> (result : Uint256):
    alloc_locals
    local result : Uint256 = toInsert
    return (result)
end

func update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr : HashBuiltin*, storage_ptr : Storage*, range_check_ptr}(
        slot_51 : Uint256, value_52 : Uint256) -> ():
    alloc_locals
    let (local _1_53 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        slot_51)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _2_54 : Uint256) = update_byte_slice_shift(_1_53, value_52)
    s_store{storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        key=slot_51, value=_2_54)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    return ()
end

func __warp_block_6{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        var_res : Uint256, var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    let (
        local _3_16 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_280{
        memory_dict=memory_dict, msize=msize}(var_src)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _4_17 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_3_16, var_sender)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _5_18 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(_4_17)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local _6_19 : Uint256) = extract_from_storage_value_dynamict_uint256(_5_18)
    let (local _7_20 : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(
        _6_19, var_wad)
    local range_check_ptr = range_check_ptr
    update_storage_value_offsett_uint256_to_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_4_17, _7_20)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_res : Uint256 = Uint256(low=1, high=0)
    return (var_res)
end

func __warp_block_4_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        __warp_subexpr_0 : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local var_res : Uint256 = Uint256(low=2, high=0)
        return (var_res)
    else:
        let (local var_res : Uint256) = __warp_block_6{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(var_res, var_sender, var_src, var_wad)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return (var_res)
    end
end

func __warp_block_2{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        match_var : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_block_4_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(__warp_subexpr_0, var_res, var_sender, var_src, var_wad)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_res)
end

func __warp_block_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _2_15 : Uint256, var_res : Uint256, var_sender : Uint256, var_src : Uint256,
        var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    local match_var : Uint256 = _2_15
    let (local var_res : Uint256) = __warp_block_2{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(match_var, var_res, var_sender, var_src, var_wad)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_res)
end

func fun_transferFrom{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(var_src : Uint256, var_wad : Uint256, var_sender : Uint256) -> (
        var : Uint256):
    alloc_locals
    local var_res : Uint256 = Uint256(low=0, high=0)
    let (local _1_14 : Uint256) = is_eq(var_src, var_sender)
    local range_check_ptr = range_check_ptr
    let (local _2_15 : Uint256) = is_zero(_1_14)
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_block_0{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_15, var_res, var_sender, var_src, var_wad)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var : Uint256 = var_res
    return (var)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
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
        memory_dict : DictAccess*, msize, range_check_ptr}(key : Uint256) -> (dataSlot : Uint256):
    alloc_locals
    local _1_21 : Uint256 = Uint256(low=0, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_1_21.low, value=key)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _2_22 : Uint256 = _1_21
    local _3_23 : Uint256 = Uint256(low=32, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_3_23.low, value=_1_21)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _4_24 : Uint256 = Uint256(low=64, high=0)
    local _5_25 : Uint256 = _1_21
    let (local dataSlot : Uint256) = sha{
        range_check_ptr=range_check_ptr, memory_dict=memory_dict, msize=msize}(_1_21.low, _4_24.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return (dataSlot)
end

func read_from_storage_split_dynamic_uint256{
        pedersen_ptr : HashBuiltin*, storage_ptr : Storage*, range_check_ptr}(
        slot_45 : Uint256) -> (value_46 : Uint256):
    alloc_locals
    let (local _1_47 : Uint256) = s_load{
        storage_ptr=storage_ptr, range_check_ptr=range_check_ptr, pedersen_ptr=pedersen_ptr}(
        slot_45)
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local value_46 : Uint256) = extract_from_storage_value_dynamict_uint256(_1_47)
    return (value_46)
end

func __warp_block_9{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256) -> ():
    alloc_locals
    local _11 : Uint256 = _4_58
    let (local param : Uint256, local param_1 : Uint256, local param_2 : Uint256,
        local param_3 : Uint256) = abi_decode_uint256t_uint256t_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_58)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_transferFrom{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(param, param_2, param_3)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local _12 : Uint256 = _2_56
    let (local memPos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_2_56.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _13 : Uint256) = abi_encode_uint256{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(
        memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _14 : Uint256) = uint256_sub(_13, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_12{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256) -> ():
    alloc_locals
    local _15 : Uint256 = Uint256(0, 0)
    __warp_block_00(_15)
    local _16 : Uint256 = _4_58
    let (local param_4 : Uint256, local param_5 : Uint256) = abi_decode_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_58)
    local range_check_ptr = range_check_ptr
    let (
        local _17 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256_278{
        memory_dict=memory_dict, msize=msize}(param_4)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (
        local _18 : Uint256) = mapping_index_access_mapping_uint256_mapping_uint256_uint256_of_uint256{
        memory_dict=memory_dict, msize=msize}(_17, param_5)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local ret_1 : Uint256) = read_from_storage_split_dynamic_uint256{
        pedersen_ptr=pedersen_ptr, storage_ptr=storage_ptr}(_18)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local _19 : Uint256 = _2_56
    let (local memPos_1 : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_2_56.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _20 : Uint256) = abi_encode_uint256{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(memPos_1, ret_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _21 : Uint256) = uint256_sub(_20, memPos_1)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_11_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256, __warp_subexpr_0 : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_12{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_2_56, _4_58)
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

func __warp_block_10{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=3433131944, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_11_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_56, _4_58, __warp_subexpr_0)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_8_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(
        _2_56 : Uint256, _4_58 : Uint256, __warp_subexpr_0 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        __warp_block_9{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_2_56, _4_58)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    else:
        __warp_block_10{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_2_56, _4_58, match_var)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return ()
    end
end

func __warp_block_7{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256, match_var : Uint256) -> ():
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=2287400825, high=0))
    local range_check_ptr = range_check_ptr
    __warp_block_8_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_56, _4_58, __warp_subexpr_0, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_5{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_10 : Uint256, _2_56 : Uint256, _4_58 : Uint256) -> ():
    alloc_locals
    local match_var : Uint256 = _10
    __warp_block_7{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_56, _4_58, match_var)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_3{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256) -> ():
    alloc_locals
    local _7_61 : Uint256 = Uint256(low=0, high=0)
    local _8_62 : Uint256 = Uint256(31597865, 9284653)
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8_62)
    local range_check_ptr = range_check_ptr
    __warp_block_5{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_10, _2_56, _4_58)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return ()
end

func __warp_block_1_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*}(_2_56 : Uint256, _4_58 : Uint256, _6_60 : Uint256) -> ():
    alloc_locals
    if _6_60.low + _6_60.high != 0:
        __warp_block_3{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr}(_2_56, _4_58)
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
    local _1_55 : Uint256 = Uint256(low=128, high=0)
    local _2_56 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_56.low, value=_1_55)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_57 : Uint256 = Uint256(low=4, high=0)
    local _4_58 : Uint256 = Uint256(31597865, 9284653)
    let (local _5_59 : Uint256) = is_lt(_4_58, _3_57)
    local range_check_ptr = range_check_ptr
    let (local _6_60 : Uint256) = is_zero(_5_59)
    local range_check_ptr = range_check_ptr
    __warp_block_1_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr}(_2_56, _4_58, _6_60)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr

    return ()
end
