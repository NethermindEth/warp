%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_gt, is_lt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not
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

func __warp_loop_body_0{range_check_ptr}(var_j : Uint256, var_k : Uint256) -> (var_k : Uint256):
    alloc_locals
    let (local _1_11 : Uint256) = is_gt(var_k, var_j)
    local range_check_ptr = range_check_ptr
    if _1_11.low + _1_11.high != 0:
        return (var_k)
    end
    let (local var_k : Uint256) = checked_sub_uint256{range_check_ptr=range_check_ptr}(var_k)
    local range_check_ptr = range_check_ptr
    let (local var_k : Uint256) = u256_add(var_k, var_j)
    local range_check_ptr = range_check_ptr
    return (var_k)
end

func __warp_block_0_if{
        memory_dict : DictAccess*, msize, pedersen_ptr : HashBuiltin*, range_check_ptr,
        storage_ptr : Storage*, syscall_ptr : felt*}(
        __warp_subexpr_0 : Uint256, var_i : Uint256, var_j : Uint256, var_k : Uint256) -> (
        var_k : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var_k : Uint256) = __warp_loop_body_0{range_check_ptr=range_check_ptr}(
            var_j, var_k)
        local range_check_ptr = range_check_ptr
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
    let (local var_k : Uint256) = __warp_block_0_if{
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
    alloc_locals
    let (memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    let (local var : Uint256) = fun_transferFrom{
        memory_dict=memory_dict,
        msize=msize,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        storage_ptr=storage_ptr,
        syscall_ptr=syscall_ptr}(Uint256(var_i_low, var_i_high), Uint256(var_j_low, var_j_high))
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var.low, var.high)
end
