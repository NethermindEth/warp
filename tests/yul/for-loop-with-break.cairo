%lang starknet
%builtins pedersen range_check

from evm.memory import mload_, mstore_
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt, u256_add
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

func abi_encode_bool_to_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        value : Uint256, pos : Uint256) -> ():
    alloc_locals
    let (local _1_1 : Uint256) = is_zero(value)
    local range_check_ptr = range_check_ptr
    let (local _2_2 : Uint256) = is_zero(_1_1)
    local range_check_ptr = range_check_ptr
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=pos.low, value=_2_2)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    return ()
end

func abi_encode_bool{memory_dict : DictAccess*, msize, range_check_ptr}(
        headStart : Uint256, value0_3 : Uint256) -> (tail : Uint256):
    alloc_locals
    local _1_4 : Uint256 = Uint256(low=32, high=0)
    let (local tail : Uint256) = u256_add(headStart, _1_4)
    local range_check_ptr = range_check_ptr
    abi_encode_bool_to_bool{memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(
        value0_3, headStart)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    return (tail)
end

func checked_sub_uint256{range_check_ptr}(x_7 : Uint256) -> (diff : Uint256):
    alloc_locals
    local _1_8 : Uint256 = Uint256(low=1, high=0)
    let (local _2_9 : Uint256) = is_lt(x_7, _1_8)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_2_9)
    let (local _3_10 : Uint256) = uint256_not(Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local diff : Uint256) = u256_add(x_7, _3_10)
    local range_check_ptr = range_check_ptr
    return (diff)
end

func __warp_block_0_if(_1_11 : Uint256, __warp_break_0 : Uint256) -> (__warp_break_0 : Uint256):
    alloc_locals
    if _1_11.low + _1_11.high != 0:
        local __warp_break_0 : Uint256 = Uint256(low=1, high=0)
        return (__warp_break_0)
    else:
        return (__warp_break_0)
    end
end

func __warp_loop_body_0{range_check_ptr}(
        __warp_break_0 : Uint256, var_j : Uint256, var_k : Uint256) -> (
        __warp_break_0 : Uint256, var_k : Uint256):
    alloc_locals
    let (local _1_11 : Uint256) = is_gt(var_k, var_j)
    local range_check_ptr = range_check_ptr
    let (local __warp_break_0 : Uint256) = __warp_block_0_if(_1_11, __warp_break_0)
    let (local var_k : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(var_k)
    local range_check_ptr = range_check_ptr
    let (local var_k : Uint256) = u256_add(var_k, var_j)
    local range_check_ptr = range_check_ptr
    return (__warp_break_0, var_k)
end

func __warp_block_3{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_i : Uint256, var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals
    local __warp_break_0 : Uint256 = Uint256(low=0, high=0)
    let (local __warp_break_0 : Uint256, local var_k : Uint256) = __warp_loop_body_0{
        range_check_ptr=range_check_ptr}(__warp_break_0, var_j, var_k)
    local range_check_ptr = range_check_ptr
    if __warp_break_0.low + __warp_break_0.high != 0:
        return (var_k)
    else:
        let (local var_k : Uint256) = __warp_loop_0{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr,
            syscall_ptr=syscall_ptr}(var_i, var_j, var_k)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
    end
    return (var_k)
end

func __warp_block_1_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_i : Uint256, var_j : Uint256, var_k : Uint256) -> (
        var_k : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var_k : Uint256) = __warp_block_3{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr,
            syscall_ptr=syscall_ptr}(var_i, var_j, var_k)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return (var_k)
    else:
        return (var_k)
    end
end

func __warp_loop_0{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        var_i : Uint256, var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_lt(var_k, var_i)
    local range_check_ptr = range_check_ptr
    let (local var_k : Uint256) = __warp_block_1_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr,
        syscall_ptr=syscall_ptr}(__warp_subexpr_0, var_i, var_j, var_k)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return (var_k)
end

func fun_transferFrom{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(var_i : Uint256, var_j : Uint256) -> (
        var : Uint256):
    alloc_locals
    local var_k : Uint256 = Uint256(low=0, high=0)
    let (local var_k : Uint256) = __warp_loop_0{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr,
        syscall_ptr=syscall_ptr}(var_i, var_j, var_k)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local var : Uint256 = Uint256(low=1, high=0)
    return (var)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_i_low, var_i_high, var_j_low, var_j_high) -> (var_low, var_high):
    let (memory_dict) = default_dict_new(0)
    let msize = 0
    let (var) = fun_transferFrom{memory_dict=memory_dict, msize=msize}(
        Uint256(var_i_low, var_i_high), Uint256(var_j_low, var_j_high))
    return (var.low, var.high)
end

func __warp_block_6{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_2_21 : Uint256, _4_23 : Uint256) -> ():
    alloc_locals
    local _13 : Uint256 = _4_23
    let (local param : Uint256, local param_1 : Uint256) = abi_decode_uint256t_uint256{
        range_check_ptr=range_check_ptr}(_4_23)
    local range_check_ptr = range_check_ptr
    let (local ret__warp_mangled : Uint256) = fun_transferFrom{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr,
        syscall_ptr=syscall_ptr}(param, param_1)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    local _14 : Uint256 = _2_21
    let (local memPos : Uint256) = mload_{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(_2_21.low)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local _15 : Uint256) = abi_encode_bool{
        memory_dict=memory_dict, msize=msize, range_check_ptr=range_check_ptr}(
        memPos, ret__warp_mangled)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local range_check_ptr = range_check_ptr
    let (local _16 : Uint256) = uint256_sub(_15, memPos)
    local range_check_ptr = range_check_ptr

    return ()
end

func __warp_block_5_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _12 : Uint256, _2_21 : Uint256, _4_23 : Uint256) -> ():
    alloc_locals
    if _12.low + _12.high != 0:
        __warp_block_6{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr,
            syscall_ptr=syscall_ptr}(_2_21, _4_23)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
        return ()
    else:
        return ()
    end
end

func __warp_block_4{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(_2_21 : Uint256, _4_23 : Uint256) -> ():
    alloc_locals
    local _7 : Uint256 = Uint256(low=0, high=0)
    local _8 : Uint256 = Uint256(31597865, 9284653)
    local _9 : Uint256 = Uint256(low=224, high=0)
    let (local _10 : Uint256) = uint256_shr(_9, _8)
    local range_check_ptr = range_check_ptr
    local _11 : Uint256 = Uint256(low=105102910, high=0)
    let (local _12 : Uint256) = is_eq(_11, _10)
    local range_check_ptr = range_check_ptr
    __warp_block_5_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr,
        syscall_ptr=syscall_ptr}(_12, _2_21, _4_23)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    return ()
end

func __warp_block_2_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        _2_21 : Uint256, _4_23 : Uint256, _6_25 : Uint256) -> ():
    alloc_locals
    if _6_25.low + _6_25.high != 0:
        __warp_block_4{
            memory_dict=memory_dict,
            msize=msize,
            pedersen_ptr=pedersen_ptr,
            range_check_ptr=range_check_ptr,
            storage_ptr=storage_ptr,
            syscall_ptr=syscall_ptr}(_2_21, _4_23)
        local memory_dict : DictAccess* = memory_dict
        local msize = msize
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        local syscall_ptr : felt* = syscall_ptr
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
    local _1_20 : Uint256 = Uint256(low=128, high=0)
    local _2_21 : Uint256 = Uint256(low=64, high=0)
    mstore_{memory_dict=memory_dict, range_check_ptr=range_check_ptr, msize=msize}(
        offset=_2_21.low, value=_1_20)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local _3_22 : Uint256 = Uint256(low=4, high=0)
    local _4_23 : Uint256 = Uint256(31597865, 9284653)
    let (local _5_24 : Uint256) = is_lt(_4_23, _3_22)
    local range_check_ptr = range_check_ptr
    let (local _6_25 : Uint256) = is_zero(_5_24)
    local range_check_ptr = range_check_ptr
    __warp_block_2_if{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr,
        syscall_ptr=syscall_ptr}(_2_21, _4_23, _6_25)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr

    return ()
end
