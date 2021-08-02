%lang starknet

%builtins pedersen range_check

from evm.array import aload
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload, mstore
from evm.output import Output, create_from_memory
from evm.sha3 import sha
from evm.stack import StackItem
from evm.uint256 import is_eq, is_gt, is_lt, is_zero
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_and, uint256_eq, uint256_exp, uint256_mul, uint256_not,
    uint256_sub, uint256_unsigned_div_rem)
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
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=64, value=Uint256(96, 0))
    local memory_dict : DictAccess* = memory_dict
    local tmp0 : Uint256 = Uint256(exec_env.input_len, 0)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp0, Uint256(4, 0))
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(163, 0), output=Output(0, cast(0, felt*), 0))
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 0)
    let (local tmp3 : Uint256, _) = uint256_unsigned_div_rem(
        tmp2, Uint256(0, 79228162514264337593543950336))
    let (local tmp4 : Uint256) = uint256_and(Uint256(4294967295, 0), tmp3)
    let (local tmp5 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(Uint256(16192718, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp5, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(168, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(128, 0), output=Output(0, cast(0, felt*), 0))
end

func segment128{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment133{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp1 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp2 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(232, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp0, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1119, 0), output=Output(0, cast(0, felt*), 0))
end

func segment196{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment198{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(253, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(1200, 0), output=Output(0, cast(0, felt*), 0))
end

func segment216{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local tmp2 : Uint256) = uint256_sub(tmp1, tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp1.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp1.low)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp3.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(Uint256(32, 0), tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp5 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp0.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    local newitem1 : StackItem = StackItem(value=tmp4, next=stack0)
    local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp5, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp5, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp4, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp6, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(253, 0), output=Output(0, cast(0, felt*), 0))
end

func segment253{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(stack0.value, stack3.value)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(317, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256, _) = uint256_add(stack1.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp2.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp2.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(stack2.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp4.low, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(stack0.value, Uint256(32, 0))
    local newitem3 : StackItem = StackItem(value=tmp5, next=stack1)
    return (stack=&newitem3, evm_pc=Uint256(290, 0), output=Output(0, cast(0, felt*), 0))
end

func segment280{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    local stack7 : StackItem* = stack6.next
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value, stack6.value)
    let (local tmp1 : Uint256) = uint256_and(Uint256(31, 0), stack4.value)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack7)
        local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
        return (stack=&newitem1, evm_pc=Uint256(362, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp3 : Uint256) = uint256_sub(tmp0, tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp4 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp3.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256) = uint256_sub(Uint256(32, 0), tmp1)
    let (local tmp6 : Uint256) = uint256_exp(Uint256(256, 0), tmp5)
    let (local tmp7 : Uint256) = uint256_sub(tmp6, Uint256(1, 0))
    let (local tmp8 : Uint256) = uint256_not(tmp7)
    let (local tmp9 : Uint256) = uint256_and(tmp8, tmp4)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp3.low, value=tmp9)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp10 : Uint256, _) = uint256_add(Uint256(32, 0), tmp3)
    local newitem0 : StackItem = StackItem(value=tmp10, next=stack7)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    return (stack=&newitem1, evm_pc=Uint256(325, 0), output=Output(0, cast(0, felt*), 0))
end

func segment325{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = uint256_sub(stack1.value, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack5, evm_pc=Uint256(0, 0), output=output)
end

func segment339{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp3 : Uint256) = aload(exec_env.input_len, exec_env.input, 68)
    let (local tmp4 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp3)
    local newitem0 : StackItem = StackItem(value=Uint256(471, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp4, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1358, 0), output=Output(0, cast(0, felt*), 0))
end

func segment433{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (local tmp3 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp2)
    let (local tmp4 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp3)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp4)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp6 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256) = uint256_sub(tmp5, tmp6)
    let (local output : Output) = create_from_memory(tmp6.low, tmp7.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment459{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(516, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(1500, 0), output=Output(0, cast(0, felt*), 0))
end

func segment477{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp2 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = uint256_sub(tmp1, tmp2)
    let (local output : Output) = create_from_memory(tmp2.low, tmp3.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment499{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(557, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(1506, 0), output=Output(0, cast(0, felt*), 0))
end

func segment517{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = uint256_and(Uint256(255, 0), stack0.value)
    let (local tmp2 : Uint256) = uint256_and(Uint256(255, 0), tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp4 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256) = uint256_sub(tmp3, tmp4)
    let (local output : Output) = create_from_memory(tmp4.low, tmp5.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment545{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    local newitem0 : StackItem = StackItem(value=Uint256(638, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1525, 0), output=Output(0, cast(0, felt*), 0))
end

func segment598{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment600{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp3 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp2)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp4 : Uint256) = aload(exec_env.input_len, exec_env.input, 68)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp5 : Uint256) = aload(exec_env.input_len, exec_env.input, 100)
    let (local tmp6 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp5)
    local newitem0 : StackItem = StackItem(value=Uint256(766, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp3, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp4, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp6, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1606, 0), output=Output(0, cast(0, felt*), 0))
end

func segment725{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (local tmp3 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp2)
    let (local tmp4 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp3)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp4)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp6 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256) = uint256_sub(tmp5, tmp6)
    let (local output : Output) = create_from_memory(tmp6.low, tmp7.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment751{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    local newitem0 : StackItem = StackItem(value=Uint256(847, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    return (stack=&newitem1, evm_pc=Uint256(2273, 0), output=Output(0, cast(0, felt*), 0))
end

func segment805{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp2 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = uint256_sub(tmp1, tmp2)
    let (local output : Output) = create_from_memory(tmp2.low, tmp3.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment827{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(888, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(2297, 0), output=Output(0, cast(0, felt*), 0))
end

func segment845{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local tmp2 : Uint256) = uint256_sub(tmp1, tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp1.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp1.low)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp3.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(Uint256(32, 0), tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp5 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp0.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    local newitem1 : StackItem = StackItem(value=tmp4, next=stack0)
    local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp5, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp5, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp4, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp6, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(882, 0), output=Output(0, cast(0, felt*), 0))
end

func segment882{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(stack0.value, stack3.value)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(952, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256, _) = uint256_add(stack1.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp2.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp2.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(stack2.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp4.low, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(stack0.value, Uint256(32, 0))
    local newitem3 : StackItem = StackItem(value=tmp5, next=stack1)
    return (stack=&newitem3, evm_pc=Uint256(925, 0), output=Output(0, cast(0, felt*), 0))
end

func segment909{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    local stack7 : StackItem* = stack6.next
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value, stack6.value)
    let (local tmp1 : Uint256) = uint256_and(Uint256(31, 0), stack4.value)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack7)
        local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
        return (stack=&newitem1, evm_pc=Uint256(997, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp3 : Uint256) = uint256_sub(tmp0, tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp4 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp3.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256) = uint256_sub(Uint256(32, 0), tmp1)
    let (local tmp6 : Uint256) = uint256_exp(Uint256(256, 0), tmp5)
    let (local tmp7 : Uint256) = uint256_sub(tmp6, Uint256(1, 0))
    let (local tmp8 : Uint256) = uint256_not(tmp7)
    let (local tmp9 : Uint256) = uint256_and(tmp8, tmp4)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp3.low, value=tmp9)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp10 : Uint256, _) = uint256_add(Uint256(32, 0), tmp3)
    local newitem0 : StackItem = StackItem(value=tmp10, next=stack7)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    return (stack=&newitem1, evm_pc=Uint256(954, 0), output=Output(0, cast(0, felt*), 0))
end

func segment954{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = uint256_sub(stack1.value, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack5, evm_pc=Uint256(0, 0), output=output)
end

func segment968{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp3 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp2)
    local newitem0 : StackItem = StackItem(value=Uint256(1097, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp3, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2455, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1053{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp2 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = uint256_sub(tmp1, tmp2)
    let (local output : Output) = create_from_memory(tmp2.low, tmp3.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment1075{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = s_load(low=tmp2.low, high=tmp2.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp4 : Uint256) = uint256_sub(tmp3, stack1.value)
    s_store(low=tmp2.low, high=tmp2.high, value_low=tmp4.low, value_high=tmp4.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack3, evm_pc=stack2.value, output=Output(0, cast(0, felt*), 0))
end

func segment1156{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = s_load(low=0, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp1 : Uint256) = uint256_and(Uint256(1, 0), tmp0)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (local tmp3 : Uint256, _) = uint256_mul(Uint256(256, 0), tmp2)
    let (local tmp4 : Uint256) = uint256_sub(tmp3, Uint256(1, 0))
    let (local tmp5 : Uint256) = uint256_and(tmp4, tmp0)
    let (local tmp6 : Uint256, _) = uint256_unsigned_div_rem(tmp5, Uint256(2, 0))
    let (local tmp7 : Uint256, _) = uint256_add(Uint256(31, 0), tmp6)
    let (local tmp8 : Uint256, _) = uint256_unsigned_div_rem(tmp7, Uint256(32, 0))
    let (local tmp9 : Uint256, _) = uint256_mul(tmp8, Uint256(32, 0))
    let (local tmp10 : Uint256, _) = uint256_add(Uint256(32, 0), tmp9)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp11 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp12 : Uint256, _) = uint256_add(tmp11, tmp10)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=64, value=tmp12)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp11.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp11.low, value=tmp6)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp13 : Uint256, _) = uint256_add(Uint256(32, 0), tmp11)
    let (local tmp14 : Uint256) = s_load(low=0, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp15 : Uint256) = uint256_and(Uint256(1, 0), tmp14)
    let (local tmp16 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp15)
    let (local tmp17 : Uint256, _) = uint256_mul(Uint256(256, 0), tmp16)
    let (local tmp18 : Uint256) = uint256_sub(tmp17, Uint256(1, 0))
    let (local tmp19 : Uint256) = uint256_and(tmp18, tmp14)
    let (local tmp20 : Uint256, _) = uint256_unsigned_div_rem(tmp19, Uint256(2, 0))
    let (local tmp21 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp20)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp21, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp11, next=stack0)
        local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem0)
        local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
        local newitem3 : StackItem = StackItem(value=tmp13, next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
        local newitem5 : StackItem = StackItem(value=tmp20, next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(1350, 0), output=Output(0, cast(0, felt*), 0))
    end
    local memory_dict : DictAccess* = memory_dict
    let (local tmp22 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(Uint256(31, 0), tmp20)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp22, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp11, next=stack0)
        local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem0)
        local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
        local newitem3 : StackItem = StackItem(value=tmp13, next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
        local newitem5 : StackItem = StackItem(value=tmp20, next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(1307, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp23 : Uint256) = s_load(low=0, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp24 : Uint256, _) = uint256_unsigned_div_rem(tmp23, Uint256(256, 0))
    let (local tmp25 : Uint256, _) = uint256_mul(tmp24, Uint256(256, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp13.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp13.low, value=tmp25)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp26 : Uint256, _) = uint256_add(Uint256(32, 0), tmp13)
    local newitem0 : StackItem = StackItem(value=tmp11, next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp26, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp20, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(1350, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1263{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=stack1.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 32)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack3)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack2.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1277, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1277{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    let (local tmp0 : Uint256) = s_load(low=stack1.value.low, high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(1, 0), stack2.value)
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), stack1.value)
    let (local tmp3 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack3.value, tmp2)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp1, next=stack3)
        local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(1321, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack3.value)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack3.value, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack4)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1306, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1306{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    local stack7 : StackItem* = stack6.next
    return (stack=stack5, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment1314{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack2.value)
    let (local tmp4 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp3)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp4)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    s_store(low=tmp5.low, high=tmp5.high, value_low=stack1.value.low, value_high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment1456{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = s_load(low=3, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
    return (stack=&newitem1, evm_pc=stack0.value, output=Output(0, cast(0, felt*), 0))
end

func segment1462{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = s_load(low=2, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp1 : Uint256, _) = uint256_unsigned_div_rem(tmp0, Uint256(1, 0))
    let (local tmp2 : Uint256) = uint256_and(Uint256(255, 0), tmp1)
    local newitem1 : StackItem = StackItem(value=tmp2, next=stack0)
    return (stack=&newitem1, evm_pc=stack0.value, output=Output(0, cast(0, felt*), 0))
end

func segment1481{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack1.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = s_load(low=tmp2.low, high=tmp2.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp4 : Uint256, _) = uint256_add(tmp3, stack0.value)
    s_store(low=tmp2.low, high=tmp2.high, value_low=tmp4.low, value_high=tmp4.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack3, evm_pc=stack2.value, output=Output(0, cast(0, felt*), 0))
end

func segment1562{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack3.value)
    let (local tmp2 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(tmp1, tmp0)
    let (local tmp3 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp2)
    let (local tmp4 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp4, Uint256(0, 0))
    if immediate == 0:
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem5 : StackItem = StackItem(value=tmp3, next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(1824, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp5 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack3.value)
    let (local tmp6 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp5)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp6)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp8 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value)
    let (local tmp9 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp8)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp9)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp7)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp10 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp11 : Uint256) = s_load(low=tmp10.low, high=tmp10.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp12 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        tmp11,
        Uint256(340282366920938463463374607431768211455, 340282366920938463463374607431768211455))
    let (local tmp13 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp12)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=tmp13, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(1780, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1780{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    let (local tmp0 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack1, evm_pc=Uint256(2107, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack5.value)
    let (local tmp2 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack2.value)
    let (local tmp5 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp4)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp5)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256) = s_load(low=tmp6.low, high=tmp6.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    let (local tmp8 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp7, stack3.value)
    let (local tmp9 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp8)
    let (local tmp10 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp9)
    let (local tmp11 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp10)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp11, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack1, evm_pc=Uint256(1968, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1924{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack4.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack1.value)
    let (local tmp4 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp3)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp4)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256) = s_load(low=tmp5.low, high=tmp5.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp7 : Uint256) = uint256_sub(tmp6, stack2.value)
    s_store(low=tmp5.low, high=tmp5.high, value_low=tmp7.low, value_high=tmp7.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack0, evm_pc=Uint256(2063, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2063{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack4.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = s_load(low=tmp2.low, high=tmp2.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp4 : Uint256) = uint256_sub(tmp3, stack2.value)
    s_store(low=tmp2.low, high=tmp2.high, value_low=tmp4.low, value_high=tmp4.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp5 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack3.value)
    let (local tmp6 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp5)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp6)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp8 : Uint256) = s_load(low=tmp7.low, high=tmp7.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp9 : Uint256, _) = uint256_add(tmp8, stack2.value)
    s_store(low=tmp7.low, high=tmp7.high, value_low=tmp9.low, value_high=tmp9.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack6)
    return (stack=&newitem0, evm_pc=stack5.value, output=Output(0, cast(0, felt*), 0))
end

func segment2229{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = s_load(low=tmp0.low, high=tmp0.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem1 : StackItem = StackItem(value=tmp1, next=stack1)
    return (stack=&newitem1, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment2253{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = s_load(low=1, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp1 : Uint256) = uint256_and(Uint256(1, 0), tmp0)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (local tmp3 : Uint256, _) = uint256_mul(Uint256(256, 0), tmp2)
    let (local tmp4 : Uint256) = uint256_sub(tmp3, Uint256(1, 0))
    let (local tmp5 : Uint256) = uint256_and(tmp4, tmp0)
    let (local tmp6 : Uint256, _) = uint256_unsigned_div_rem(tmp5, Uint256(2, 0))
    let (local tmp7 : Uint256, _) = uint256_add(Uint256(31, 0), tmp6)
    let (local tmp8 : Uint256, _) = uint256_unsigned_div_rem(tmp7, Uint256(32, 0))
    let (local tmp9 : Uint256, _) = uint256_mul(tmp8, Uint256(32, 0))
    let (local tmp10 : Uint256, _) = uint256_add(Uint256(32, 0), tmp9)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp11 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp12 : Uint256, _) = uint256_add(tmp11, tmp10)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=64, value=tmp12)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp11.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp11.low, value=tmp6)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp13 : Uint256, _) = uint256_add(Uint256(32, 0), tmp11)
    let (local tmp14 : Uint256) = s_load(low=1, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp15 : Uint256) = uint256_and(Uint256(1, 0), tmp14)
    let (local tmp16 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp15)
    let (local tmp17 : Uint256, _) = uint256_mul(Uint256(256, 0), tmp16)
    let (local tmp18 : Uint256) = uint256_sub(tmp17, Uint256(1, 0))
    let (local tmp19 : Uint256) = uint256_and(tmp18, tmp14)
    let (local tmp20 : Uint256, _) = uint256_unsigned_div_rem(tmp19, Uint256(2, 0))
    let (local tmp21 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp20)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp21, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp11, next=stack0)
        local newitem1 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem0)
        local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
        local newitem3 : StackItem = StackItem(value=tmp13, next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem3)
        local newitem5 : StackItem = StackItem(value=tmp20, next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(2447, 0), output=Output(0, cast(0, felt*), 0))
    end
    local memory_dict : DictAccess* = memory_dict
    let (local tmp22 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(Uint256(31, 0), tmp20)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp22, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp11, next=stack0)
        local newitem1 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem0)
        local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
        local newitem3 : StackItem = StackItem(value=tmp13, next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem3)
        local newitem5 : StackItem = StackItem(value=tmp20, next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(2404, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp23 : Uint256) = s_load(low=1, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp24 : Uint256, _) = uint256_unsigned_div_rem(tmp23, Uint256(256, 0))
    let (local tmp25 : Uint256, _) = uint256_mul(tmp24, Uint256(256, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp13.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp13.low, value=tmp25)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp26 : Uint256, _) = uint256_add(Uint256(32, 0), tmp13)
    local newitem0 : StackItem = StackItem(value=tmp11, next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp6, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp26, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp20, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(2447, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2360{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=stack1.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 32)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack3)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack2.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2374, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2374{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    let (local tmp0 : Uint256) = s_load(low=stack1.value.low, high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(1, 0), stack2.value)
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), stack1.value)
    let (local tmp3 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack3.value, tmp2)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp1, next=stack3)
        local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(2418, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack3.value)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack3.value, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack4)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2403, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2403{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    local stack7 : StackItem* = stack6.next
    return (stack=stack5, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment2411{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=stack1.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = s_load(low=tmp1.low, high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem1 : StackItem = StackItem(value=tmp2, next=stack2)
    return (stack=&newitem1, evm_pc=stack2.value, output=Output(0, cast(0, felt*), 0))
end

func run_from{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(
        exec_env : ExecutionEnvironment*, evm_pc : Uint256, stack : StackItem*) -> (
        stack : StackItem*, output : Output):
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(0, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment0(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(128, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment128(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(133, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment133(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(196, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment196(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(198, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment198(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(216, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment216(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(253, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment253(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(280, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment280(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(325, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment325(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(339, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment339(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(433, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment433(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(459, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment459(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(477, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment477(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(499, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment499(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(517, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment517(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(545, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment545(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(598, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment598(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(600, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment600(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(725, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment725(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(751, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment751(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(805, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment805(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(827, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment827(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(845, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment845(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(882, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment882(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(909, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment909(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(954, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment954(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(968, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment968(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1053, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1053(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1075, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1075(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1156, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1156(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1263, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1263(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1277, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1277(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1306, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1306(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1314, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1314(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1456, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1456(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1462, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1462(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1481, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1481(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1562, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1562(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1780, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1780(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1924, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1924(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2063, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2063(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2229, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2229(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2253, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2253(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2360, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2360(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2374, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2374(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2403, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2403(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2411, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2411(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(-1, 0))
    if immediate == 1:
        return (stack, Output(1, cast(0, felt*), 0))
    end
    # Fail.
    assert 0 = 1
    jmp rel 0
end

@external
func main{storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        unused_bits, payload_len, payload : felt*, pc_entry):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()

    local exec_env : ExecutionEnvironment = ExecutionEnvironment(
        payload_len=payload_len,
        payload=payload,
        )

    let (local memory_dict : DictAccess*) = default_dict_new(0)
    local memory_start : DictAccess* = memory_dict

    tempvar msize = 0

    local stack0 : StackItem
    assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.

    let (local stack, local output) = run_from{
        storage_ptr=storage_ptr,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        msize=msize,
        memory_dict=memory_dict}(&exec_env, Uint256(pc_entry, 0), &stack0)

    return ()
end
