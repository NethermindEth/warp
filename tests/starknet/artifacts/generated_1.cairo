%lang starknet

%builtins pedersen range_check

from evm.array import array_load, copy_to_memory
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload
from evm.output import Output
from evm.stack import StackItem
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, uint256_addmod, uint256_byte, uint256_exp
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_and, uint256_eq, uint256_unsigned_div_rem)
from starkware.starknet.common.storage import Storage

@storage_var
func evm_storage(low : felt, high : felt, part : felt) -> (res : felt):
end

func s_load{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : Uint256):
    let (low_r) = evm_storage.read(low, high, 1)
    let (high_r) = evm_storage.read(low, high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt, value_low : felt, value_high : felt):
    evm_storage.write(low=low, high=high, part=1, value=value_low)
    evm_storage.write(low=low, high=high, part=2, value=value_high)
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

func segment0{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    s_store(low=0, high=0, value_low=21, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=1, high=0, value_low=4911261143028855952388095, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=2, high=0, value_low=46, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=3, high=0, value_low=0, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 0, 3)
    local memory_dict : DictAccess* = memory_dict
    copy_to_memory(exec_env.input_len, exec_env.input, 0, 65535, 3)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 65535, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        65535)
    local memory_dict : DictAccess* = memory_dict
    s_store(low=4, high=0, value_low=tmp0.low, value_high=tmp0.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 0, 8)
    local memory_dict : DictAccess* = memory_dict
    copy_to_memory(exec_env.input_len, exec_env.input, 0, 43981, 8)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 43981, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp1 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        43981)
    local memory_dict : DictAccess* = memory_dict
    s_store(low=5, high=0, value_low=tmp1.low, value_high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp2 : Uint256) = array_load(exec_env.input_len, exec_env.input, 0)
    s_store(low=6, high=0, value_low=tmp2.low, value_high=tmp2.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=7, high=0, value_low=10, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=8, high=0, value_low=0, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=9, high=0, value_low=1, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=10, high=0, value_low=16, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=11, high=0, value_low=18446744073709551616, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=12, high=0, value_low=0, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=13, high=0, value_low=1, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=14, high=0, value_low=1, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=15, high=0, value_low=0, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    s_store(low=16, high=0, value_low=1, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(3, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(65535, 0), next=&newitem0)
    return (&newitem1, Output(cast(0, felt*), 0))
end

func run_from{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(
        exec_env : ExecutionEnvironment*, evm_pc, stack : StackItem*) -> (
        stack : StackItem*, output : Output):
    if evm_pc == 0:
        return segment0(exec_env, stack)
    end
    if evm_pc == -1:
        return (stack, Output(cast(0, felt*), 0))
    end
    # Fail.
    assert 0 = 1
    jmp rel 0
end

@external
func main{storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        calldata_size, unused_bytes, input_len : felt, input : felt*):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=calldata_size,
        input_len=input_len,
        input=input,
        )

    let (local memory_dict : DictAccess*) = default_dict_new(0)
    local memory_start : DictAccess* = memory_dict

    tempvar msize = 0

    local stack0 : StackItem
    assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.

    let (local stack, local output) = segment0{
        storage_ptr=storage_ptr,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        msize=msize,
        memory_dict=memory_dict}(&exec_env, &stack0)

    return ()
end
