%lang starknet
%builtins pedersen range_check

from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_eq, is_lt, is_zero
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_sub
from starkware.starknet.common.storage import Storage

@storage_var
func allowance(arg0_low, arg0_high, arg1_low, arg1_high) -> (res : Uint256):
end

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

func checked_sub_uint256{range_check_ptr}(x : Uint256, y : Uint256) -> (diff : Uint256):
    alloc_locals
    let (local _1_12 : Uint256) = is_lt(x, y)
    local range_check_ptr = range_check_ptr
    __warp_block_00(_1_12)
    let (local diff : Uint256) = uint256_sub(x, y)
    local range_check_ptr = range_check_ptr
    return (diff)
end

@view
func getter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0 : Uint256, arg1 : Uint256) -> (value_17 : Uint256):
    alloc_locals
    let (res) = allowance.read(arg0.low, arg0.high, arg1.low, arg1.high)
    return (res)
end

@external
func setter_fun_allowance{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        arg0_28 : Uint256, arg1_29 : Uint256, value_30 : Uint256) -> ():
    alloc_locals
    allowance.write(arg0_28.low, arg0_28.high, arg1_29.low, arg1_29.high, value_30)
    return ()
end

func __warp_block_3{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (var_res : Uint256):
    alloc_locals
    let (local _3_15 : Uint256) = getter_fun_allowance(var_src, var_sender)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local _4_16 : Uint256) = checked_sub_uint256(_3_15, var_wad)
    local range_check_ptr = range_check_ptr
    setter_fun_allowance(var_src, var_sender, _4_16)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var_res : Uint256 = Uint256(low=1, high=0)
    return (var_res)
end

func __warp_block_2_if{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        __warp_subexpr_0 : Uint256, var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        local var_res : Uint256 = Uint256(low=2, high=0)
        return (var_res)
    else:
        let (local var_res : Uint256) = __warp_block_3(var_sender, var_src, var_wad)
        local pedersen_ptr : HashBuiltin* = pedersen_ptr
        local range_check_ptr = range_check_ptr
        local storage_ptr : Storage* = storage_ptr
        return (var_res)
    end
end

func __warp_block_1{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        match_var : Uint256, var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_block_2_if(
        __warp_subexpr_0, var_sender, var_src, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_res)
end

func __warp_block_0{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        _2_14 : Uint256, var_sender : Uint256, var_src : Uint256, var_wad : Uint256) -> (
        var_res : Uint256):
    alloc_locals
    local match_var : Uint256 = _2_14
    let (local var_res : Uint256) = __warp_block_1(match_var, var_sender, var_src, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    return (var_res)
end

func fun_transferFrom{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*}(
        var_src : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    local var_res : Uint256 = Uint256(low=0, high=0)
    let (local _1_13 : Uint256) = is_eq(var_src, var_sender)
    local range_check_ptr = range_check_ptr
    let (local _2_14 : Uint256) = is_zero(_1_13)
    local range_check_ptr = range_check_ptr
    let (local var_res : Uint256) = __warp_block_0(_2_14, var_sender, var_src, var_wad)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local var : Uint256 = var_res
    return (var)
end

@external
func fun_transferFrom_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_src : Uint256, var_wad : Uint256, var_sender : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_transferFrom(var_src, var_wad, var_sender)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end
