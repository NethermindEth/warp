%lang starknet
%builtins pedersen range_check

from evm.array import array_copy_to_memory, array_create_from_memory
from evm.exec_env import ExecutionEnvironment
from evm.uint256 import is_eq, is_gt, u256_add
from evm.utils import update_msize
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_not
from starkware.starknet.common.storage import Storage

<<<<<<< HEAD
func __warp_cond_revert(_4 : Uint256) -> ():
=======
@contract_interface
namespace GenericCallInterface:
    func fun_ENTRY_POINT(calldata_size : felt, calldata_len : felt, calldata : felt*) -> (
            success : felt, returndata_len : felt, returndata : felt*):
    end
end

func calculate_data_len{range_check_ptr}(calldata_size) -> (calldata_len):
    let (calldata_len_, rem) = unsigned_div_rem(calldata_size, 8)
    if rem != 0:
        return (calldata_len=calldata_len_ + 1)
    else:
        return (calldata_len=calldata_len_)
    end
end

func warp_call{
        syscall_ptr : felt*, storage_ptr : Storage*, exec_env : ExecutionEnvironment,
        memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, value : Uint256, in : Uint256, insize : Uint256,
        out : Uint256, outsize : Uint256) -> (success : Uint256):
    alloc_locals
    local memory_dict : DictAccess* = memory_dict

    # TODO will 128 bits be enough for addresses
    let (local mem : felt*) = array_create_from_memory{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr}(in.low, insize.low)
    local memory_dict : DictAccess* = memory_dict
    let (calldata_len_, rem) = unsigned_div_rem(insize.low, 8)
    let (calldata_len) = calculate_data_len(insize.low)
    let (local success, local return_size,
        local return_ : felt*) = GenericCallInterface.fun_ENTRY_POINT(
        address.low, insize.low, calldata_len, mem)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    array_copy_to_memory(return_size, return_, 0, out.low, outsize.low)
    let (returndata_len) = calculate_data_len(insize.low)
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size, calldata_len=exec_env.calldata_len, calldata=exec_env.calldata,
        returndata_size=return_size, returndata_len=returndata_len, returndata=return_
        )
    return (Uint256(success, 0))
end

func warp_static_call{
        syscall_ptr : felt*, storage_ptr : Storage*, exec_env : ExecutionEnvironment,
        memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, in : Uint256, insize : Uint256, out : Uint256,
        outsize : Uint256) -> (success : Uint256):
    return warp_call(gas, address, Uint256(0, 0), in, insize, out, outsize)
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

func __warp__id(arg : Uint256) -> (res : Uint256):
    return (res=arg)
end

func __warp_cond_revert(_4_4 : Uint256) -> ():
>>>>>>> staticcall
    alloc_locals
    if _4_4.low + _4_4.high != 0:
        assert 0 = 1
        jmp rel 0
    else:
        return ()
    end
end

func checked_add_uint256_141{range_check_ptr}(x : Uint256) -> (sum : Uint256):
    alloc_locals
    let (local _1_9 : Uint256) = uint256_not(Uint256(low=42, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_10 : Uint256) = is_gt(x, _1_9)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_10)
    local _3_11 : Uint256 = Uint256(low=42, high=0)
    let (local sum : Uint256) = u256_add(x, _3_11)
    local range_check_ptr = range_check_ptr
    return (sum)
end

func checked_add_uint256{range_check_ptr}(x_12 : Uint256) -> (sum_13 : Uint256):
    alloc_locals
    let (local _1_14 : Uint256) = uint256_not(Uint256(low=21, high=0))
    local range_check_ptr = range_check_ptr
    let (local _2_15 : Uint256) = is_gt(x_12, _1_14)
    local range_check_ptr = range_check_ptr
    __warp_cond_revert(_2_15)
    local _3_16 : Uint256 = Uint256(low=21, high=0)
    let (local sum_13 : Uint256) = u256_add(x_12, _3_16)
    local range_check_ptr = range_check_ptr
    return (sum_13)
end

func __warp_block_1{range_check_ptr}(match_var : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_3 : Uint256, var : Uint256):
    alloc_locals
    let (local __warp_subexpr_0 : Uint256) = is_eq(match_var, Uint256(low=0, high=0))
    local range_check_ptr = range_check_ptr
    if __warp_subexpr_0.low + __warp_subexpr_0.high != 0:
        let (local var : Uint256) = checked_add_uint256_141(var_b)
        local range_check_ptr = range_check_ptr
        local __warp_leave_3 : Uint256 = Uint256(low=1, high=0)
        return (__warp_leave_3, var)
    else:
        let (local var : Uint256) = checked_add_uint256(var_a)
        local range_check_ptr = range_check_ptr
        local __warp_leave_3 : Uint256 = Uint256(low=1, high=0)
        return (__warp_leave_3, var)
    end
end

func __warp_block_0{range_check_ptr}(_1_17 : Uint256, var_a : Uint256, var_b : Uint256) -> (
        __warp_leave_3 : Uint256, var : Uint256):
    alloc_locals
    local match_var : Uint256 = _1_17
    let (local __warp_leave_3 : Uint256, local var : Uint256) = __warp_block_1(
        match_var, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_3.low + __warp_leave_3.high != 0:
        return (__warp_leave_3, var)
    else:
        return (__warp_leave_3, var)
    end
end

func fun_rando{range_check_ptr}(var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    local __warp_leave_3 : Uint256 = Uint256(low=0, high=0)
    let (local _1_17 : Uint256) = is_gt(var_a, var_b)
    local range_check_ptr = range_check_ptr
    let (local __warp_leave_3 : Uint256, local var : Uint256) = __warp_block_0(_1_17, var_a, var_b)
    local range_check_ptr = range_check_ptr
    if __warp_leave_3.low + __warp_leave_3.high != 0:
        return (var)
    else:
        return (var)
    end
end

@external
func fun_rando_external{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        var_a : Uint256, var_b : Uint256) -> (var : Uint256):
    alloc_locals
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    with memory_dict, msize:
        let (local var : Uint256) = fun_rando(var_a, var_b)
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local range_check_ptr = range_check_ptr
    local storage_ptr : Storage* = storage_ptr
    local syscall_ptr : felt* = syscall_ptr
    default_dict_finalize(memory_dict_start, memory_dict, 0)
    return (var=var)
end

@external
func fun_ENTRY_POINT{
        pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt*}(
        calldata_size, calldata_len, calldata : felt*) -> ():
    alloc_locals
    let (returndata_ptr : felt*) = alloc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata, returndata_size=0, returndata_len=0, returndata=returndata_ptr)
    let (local memory_dict) = default_dict_new(0)
    local memory_dict_start : DictAccess* = memory_dict
    let msize = 0
    assert 0 = 1
    jmp rel 0
end
