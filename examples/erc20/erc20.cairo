%lang starknet

%builtins pedersen range_check

from evm.array import aload
from evm.exec_env import ExecutionEnvironment
from evm.memory import mload, mstore
from evm.output import Output, create_from_memory
from evm.sha3 import sha
from evm.stack import StackItem
from evm.uint256 import is_eq, is_gt, is_lt, is_zero, slt
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_and, uint256_eq, uint256_exp, uint256_mul, uint256_not,
    uint256_shr, uint256_sub, uint256_unsigned_div_rem)
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
        offset=64, value=Uint256(128, 0))
    local memory_dict : DictAccess* = memory_dict
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp0, Uint256(4, 0))
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(144, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 0)
    let (local tmp3 : Uint256) = uint256_shr(Uint256(224, 0), tmp2)
    let (local tmp4 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(
        Uint256(1206382372, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp4, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(89, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp5 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1206382372, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp5, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(367, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp6 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1607020700, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp6, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(395, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp7 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1889567281, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp7, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(456, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp8 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(2514000705, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp8, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(517, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp9 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(3714247998, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp9, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(560, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(144, 0), output=Output(0, cast(0, felt*), 0))
end

func segment89{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(16192718, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(149, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp1 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(117300739, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(177, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(309457050, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(220, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp3 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(404098525, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(281, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(826074471, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp4, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(324, 0), output=Output(0, cast(0, felt*), 0))
    end
    return (stack=stack0, evm_pc=Uint256(145, 0), output=Output(0, cast(0, felt*), 0))
end

func segment144{
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

func segment149{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    let (local tmp1 : Uint256) = uint256_sub(tmp0, Uint256(4, 0))
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(4, 0), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(175, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(170, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2406, 0), output=Output(0, cast(0, felt*), 0))
end

func segment170{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(621, 0), output=Output(0, cast(0, felt*), 0))
end

func segment175{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment177{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(189, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment189{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem0 : StackItem = StackItem(value=Uint256(198, 0), next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(711, 0), output=Output(0, cast(0, felt*), 0))
end

func segment198{
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
    local newitem0 : StackItem = StackItem(value=Uint256(211, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2599, 0), output=Output(0, cast(0, felt*), 0))
end

func segment211{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment220{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(232, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment232{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    let (local tmp1 : Uint256) = uint256_sub(tmp0, Uint256(4, 0))
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(4, 0), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(259, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(254, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2323, 0), output=Output(0, cast(0, felt*), 0))
end

func segment254{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(853, 0), output=Output(0, cast(0, felt*), 0))
end

func segment259{
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
    local newitem0 : StackItem = StackItem(value=Uint256(272, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2572, 0), output=Output(0, cast(0, felt*), 0))
end

func segment272{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment281{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(293, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment293{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem0 : StackItem = StackItem(value=Uint256(302, 0), next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(995, 0), output=Output(0, cast(0, felt*), 0))
end

func segment302{
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
    local newitem0 : StackItem = StackItem(value=Uint256(315, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2633, 0), output=Output(0, cast(0, felt*), 0))
end

func segment315{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment324{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(336, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment336{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem0 : StackItem = StackItem(value=Uint256(345, 0), next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(1001, 0), output=Output(0, cast(0, felt*), 0))
end

func segment345{
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
    local newitem0 : StackItem = StackItem(value=Uint256(358, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2660, 0), output=Output(0, cast(0, felt*), 0))
end

func segment358{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment367{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    let (local tmp1 : Uint256) = uint256_sub(tmp0, Uint256(4, 0))
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(4, 0), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(393, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(388, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2259, 0), output=Output(0, cast(0, felt*), 0))
end

func segment388{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(1020, 0), output=Output(0, cast(0, felt*), 0))
end

func segment393{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment395{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(407, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment407{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    let (local tmp1 : Uint256) = uint256_sub(tmp0, Uint256(4, 0))
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(4, 0), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(434, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(429, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2156, 0), output=Output(0, cast(0, felt*), 0))
end

func segment429{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(1110, 0), output=Output(0, cast(0, felt*), 0))
end

func segment434{
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
    local newitem0 : StackItem = StackItem(value=Uint256(447, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2572, 0), output=Output(0, cast(0, felt*), 0))
end

func segment447{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment456{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(468, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment468{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    let (local tmp1 : Uint256) = uint256_sub(tmp0, Uint256(4, 0))
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(4, 0), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(495, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(490, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2047, 0), output=Output(0, cast(0, felt*), 0))
end

func segment490{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(1802, 0), output=Output(0, cast(0, felt*), 0))
end

func segment495{
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
    local newitem0 : StackItem = StackItem(value=Uint256(508, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2633, 0), output=Output(0, cast(0, felt*), 0))
end

func segment508{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment517{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(529, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment529{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem0 : StackItem = StackItem(value=Uint256(538, 0), next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(1826, 0), output=Output(0, cast(0, felt*), 0))
end

func segment538{
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
    local newitem0 : StackItem = StackItem(value=Uint256(551, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2599, 0), output=Output(0, cast(0, felt*), 0))
end

func segment551{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment560{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(1000, 1000)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(572, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment572{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    let (local tmp1 : Uint256) = uint256_sub(tmp0, Uint256(4, 0))
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(4, 0), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(599, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(594, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2092, 0), output=Output(0, cast(0, felt*), 0))
end

func segment594{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(1968, 0), output=Output(0, cast(0, felt*), 0))
end

func segment599{
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
    local newitem0 : StackItem = StackItem(value=Uint256(612, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2633, 0), output=Output(0, cast(0, felt*), 0))
end

func segment612{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value.low, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment621{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value.low)
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
    local newitem2 : StackItem = StackItem(value=stack1.value, next=stack0)
    local newitem3 : StackItem = StackItem(value=tmp2, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(700, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack1.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp3, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2801, 0), output=Output(0, cast(0, felt*), 0))
end

func segment700{
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
    s_store(
        low=stack2.value.low.low,
        high=stack2.value.low.high,
        value_low=stack0.value.low.low,
        value_high=stack0.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack7, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment711{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = s_load(low=0, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(724, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2989, 0), output=Output(0, cast(0, felt*), 0))
end

func segment724{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(Uint256(31, 0), stack0.value.low)
    let (local tmp1 : Uint256, _) = uint256_unsigned_div_rem(tmp0, Uint256(32, 0))
    let (local tmp2 : Uint256, _) = uint256_mul(tmp1, Uint256(32, 0))
    let (local tmp3 : Uint256, _) = uint256_add(Uint256(32, 0), tmp2)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp4 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(tmp4, tmp3)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=64, value=tmp5)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp4.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(32, 0), tmp4)
    let (local tmp7 : Uint256) = s_load(low=stack1.value.low.low, high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=tmp4, next=stack2)
    local newitem1 : StackItem = StackItem(value=stack1.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp6, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack1.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(768, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp7, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(2989, 0), output=Output(0, cast(0, felt*), 0))
end

func segment768{
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
    let (local tmp0 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(845, 0), output=Output(0, cast(0, felt*), 0))
    end
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(
        Uint256(31, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(802, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = s_load(low=stack1.value.low.low, high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp3 : Uint256, _) = uint256_unsigned_div_rem(tmp2, Uint256(256, 0))
    let (local tmp4 : Uint256, _) = uint256_mul(tmp3, Uint256(256, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp4.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(Uint256(32, 0), stack3.value.low)
    local newitem0 : StackItem = StackItem(value=tmp5, next=stack4)
    local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(845, 0), output=Output(0, cast(0, felt*), 0))
end

func segment802{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value.low, stack0.value.low)
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
    return (stack=&newitem2, evm_pc=Uint256(817, 0), output=Output(0, cast(0, felt*), 0))
end

func segment816{
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
    let (local tmp0 : Uint256) = s_load(low=stack1.value.low.low, high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(1, 0), stack2.value.low)
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), stack1.value.low)
    let (local tmp3 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack3.value.low, tmp2)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp1, next=stack3)
        local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(816, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack3.value.low)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack3.value.low, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack4)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(846, 0), output=Output(0, cast(0, felt*), 0))
end

func segment845{
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

func segment853{
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value.low)
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack2.value.low)
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
    s_store(
        low=tmp5.low,
        high=tmp5.high,
        value_low=stack1.value.low.low,
        value_high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment995{
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

func segment1001{
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

func segment1020{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack1.value.low)
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
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack0)
    local newitem3 : StackItem = StackItem(value=tmp2, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(1099, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack0.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp3, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2715, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1099{
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
    s_store(
        low=stack2.value.low.low,
        high=stack2.value.low.high,
        value_low=stack0.value.low.low,
        value_high=stack0.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack7, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment1110{
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value.low)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack3.value.low)
    let (local tmp2 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(tmp1, tmp0)
    let (local tmp3 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp2)
    let (local tmp4 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp4, Uint256(0, 0))
    if immediate == 0:
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem5 : StackItem = StackItem(value=tmp3, next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(1328, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp5 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack3.value.low)
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack0.value.low)
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
        Uint256(340282366920938463463374607431768211455, 170141183460469231731687303715884105727))
    let (local tmp13 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp12)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=tmp13, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(1329, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1328{
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
    let (local tmp0 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack1, evm_pc=Uint256(1618, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack5.value.low)
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack2.value.low)
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
    let (local tmp8 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp7, stack3.value.low)
    let (local tmp9 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp8)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp9, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack1, evm_pc=Uint256(1470, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1470{
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack4.value.low)
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack1.value.low)
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
    local newitem5 : StackItem = StackItem(value=stack2.value, next=stack0)
    local newitem6 : StackItem = StackItem(value=tmp5, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=Uint256(1610, 0), next=&newitem7)
    local newitem9 : StackItem = StackItem(value=stack2.value, next=&newitem8)
    local newitem10 : StackItem = StackItem(value=tmp6, next=&newitem9)
    return (stack=&newitem10, evm_pc=Uint256(2801, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1610{
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
    s_store(
        low=stack2.value.low.low,
        high=stack2.value.low.high,
        value_low=stack0.value.low.low,
        value_high=stack0.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack4, evm_pc=Uint256(1619, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1618{
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
        Uint256(340282366920938463463374607431768211455, 4294967295), stack4.value.low)
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
    local newitem5 : StackItem = StackItem(value=stack2.value, next=stack0)
    local newitem6 : StackItem = StackItem(value=tmp2, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=Uint256(1697, 0), next=&newitem7)
    local newitem9 : StackItem = StackItem(value=stack2.value, next=&newitem8)
    local newitem10 : StackItem = StackItem(value=tmp3, next=&newitem9)
    return (stack=&newitem10, evm_pc=Uint256(2801, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1697{
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
    local stack8 : StackItem* = stack7.next
    s_store(
        low=stack2.value.low.low,
        high=stack2.value.low.high,
        value_low=stack0.value.low.low,
        value_high=stack0.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), stack7.value.low)
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
    local newitem4 : StackItem = StackItem(value=stack6.value, next=stack4)
    local newitem5 : StackItem = StackItem(value=tmp2, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(1783, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=stack6.value, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=tmp3, next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(2715, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1783{
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
    local stack8 : StackItem* = stack7.next
    local stack9 : StackItem* = stack8.next
    local stack10 : StackItem* = stack9.next
    s_store(
        low=stack2.value.low.low,
        high=stack2.value.low.high,
        value_low=stack0.value.low.low,
        value_high=stack0.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack10)
    return (stack=&newitem0, evm_pc=stack9.value, output=Output(0, cast(0, felt*), 0))
end

func segment1802{
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

func segment1826{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = s_load(low=1, high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(1839, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2989, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1839{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(Uint256(31, 0), stack0.value.low)
    let (local tmp1 : Uint256, _) = uint256_unsigned_div_rem(tmp0, Uint256(32, 0))
    let (local tmp2 : Uint256, _) = uint256_mul(tmp1, Uint256(32, 0))
    let (local tmp3 : Uint256, _) = uint256_add(Uint256(32, 0), tmp2)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp4 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(64)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(tmp4, tmp3)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 64, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=64, value=tmp5)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp4.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(32, 0), tmp4)
    let (local tmp7 : Uint256) = s_load(low=stack1.value.low.low, high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=tmp4, next=stack2)
    local newitem1 : StackItem = StackItem(value=stack1.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp6, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack1.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(1883, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp7, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(2989, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1883{
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
    let (local tmp0 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1960, 0), output=Output(0, cast(0, felt*), 0))
    end
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(
        Uint256(31, 0), stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1917, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = s_load(low=stack1.value.low.low, high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp3 : Uint256, _) = uint256_unsigned_div_rem(tmp2, Uint256(256, 0))
    let (local tmp4 : Uint256, _) = uint256_mul(tmp3, Uint256(256, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp4.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(Uint256(32, 0), stack3.value.low)
    local newitem0 : StackItem = StackItem(value=tmp5, next=stack4)
    local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1960, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1917{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value.low, stack0.value.low)
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
    return (stack=&newitem2, evm_pc=Uint256(1932, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1931{
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
    let (local tmp0 : Uint256) = s_load(low=stack1.value.low.low, high=stack1.value.low.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp0.low, value=stack0.value)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(1, 0), stack2.value.low)
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), stack1.value.low)
    let (local tmp3 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack3.value.low, tmp2)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp1, next=stack3)
        local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(1931, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack3.value.low)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack3.value.low, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack4)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1961, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1960{
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

func segment1968{
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

func segment2005{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, stack0.value.low)
    local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem2 : StackItem = StackItem(value=Uint256(2020, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp0, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(3155, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2020{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2026{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, stack0.value.low)
    local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem2 : StackItem = StackItem(value=Uint256(2041, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp0, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(3178, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2041{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2047{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(32, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem2, evm_pc=Uint256(2069, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(2068, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(3133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2068{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2070, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2069{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256, _) = uint256_add(stack1.value.low, Uint256(0, 0))
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem4 : StackItem = StackItem(value=Uint256(2083, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack2.value, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp0, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2083{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack6)
    return (stack=&newitem0, evm_pc=stack5.value, output=Output(0, cast(0, felt*), 0))
end

func segment2092{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(64, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        return (stack=&newitem3, evm_pc=Uint256(2115, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(2114, 0), next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(3133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2114{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2116, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2115{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value.low, Uint256(0, 0))
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=Uint256(2129, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack3.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2129{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value.low, Uint256(32, 0))
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem3 : StackItem = StackItem(value=stack2.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(32, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(2146, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack5.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2146{
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
    local newitem0 : StackItem = StackItem(value=stack3.value, next=stack7)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    return (stack=&newitem1, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment2156{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(128, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
        local newitem5 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(2182, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(2181, 0), next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(3133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2181{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2183, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2182{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value.low, Uint256(0, 0))
    local newitem6 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem7 : StackItem = StackItem(value=Uint256(2196, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=stack5.value, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=tmp0, next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2196{
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
    local stack8 : StackItem* = stack7.next
    let (local tmp0 : Uint256, _) = uint256_add(stack6.value.low, Uint256(32, 0))
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack6)
    local newitem3 : StackItem = StackItem(value=stack4.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack3.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack2.value, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(32, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(2213, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=stack7.value, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=tmp0, next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2213{
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
    local stack8 : StackItem* = stack7.next
    let (local tmp0 : Uint256, _) = uint256_add(stack6.value.low, Uint256(64, 0))
    local newitem3 : StackItem = StackItem(value=stack0.value, next=stack5)
    local newitem4 : StackItem = StackItem(value=stack3.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack2.value, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(64, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(2230, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=stack7.value, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=tmp0, next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(2026, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2230{
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
    local stack8 : StackItem* = stack7.next
    let (local tmp0 : Uint256, _) = uint256_add(stack6.value.low, Uint256(96, 0))
    local newitem4 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem5 : StackItem = StackItem(value=stack2.value, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(96, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(2247, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=stack7.value, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=tmp0, next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2247{
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
    local stack8 : StackItem* = stack7.next
    local stack9 : StackItem* = stack8.next
    local newitem0 : StackItem = StackItem(value=stack5.value, next=stack9)
    local newitem1 : StackItem = StackItem(value=stack4.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack0.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=stack8.value, output=Output(0, cast(0, felt*), 0))
end

func segment2259{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(64, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        return (stack=&newitem3, evm_pc=Uint256(2282, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(2281, 0), next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(3133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2281{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2283, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2282{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value.low, Uint256(0, 0))
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=Uint256(2296, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack3.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2296{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value.low, Uint256(32, 0))
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem3 : StackItem = StackItem(value=stack2.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(32, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(2313, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack5.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2026, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2313{
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
    local newitem0 : StackItem = StackItem(value=stack3.value, next=stack7)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    return (stack=&newitem1, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment2323{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(96, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
        return (stack=&newitem4, evm_pc=Uint256(2348, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(2347, 0), next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(3133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2347{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2349, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2348{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack3.value.low, Uint256(0, 0))
    local newitem5 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem6 : StackItem = StackItem(value=Uint256(2362, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=stack4.value, next=&newitem6)
    local newitem8 : StackItem = StackItem(value=tmp0, next=&newitem7)
    return (stack=&newitem8, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2362{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack5.value.low, Uint256(32, 0))
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack5)
    local newitem3 : StackItem = StackItem(value=stack3.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack2.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(32, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(2379, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=stack6.value, next=&newitem6)
    local newitem8 : StackItem = StackItem(value=tmp0, next=&newitem7)
    return (stack=&newitem8, evm_pc=Uint256(2026, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2379{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack5.value.low, Uint256(64, 0))
    local newitem3 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem4 : StackItem = StackItem(value=stack2.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(64, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(2396, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=stack6.value, next=&newitem6)
    local newitem8 : StackItem = StackItem(value=tmp0, next=&newitem7)
    return (stack=&newitem8, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2396{
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
    local stack8 : StackItem* = stack7.next
    local newitem0 : StackItem = StackItem(value=stack4.value, next=stack8)
    local newitem1 : StackItem = StackItem(value=stack3.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=stack7.value, output=Output(0, cast(0, felt*), 0))
end

func segment2406{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(64, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        return (stack=&newitem3, evm_pc=Uint256(2429, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(2428, 0), next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(3133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2428{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2430, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2429{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack2.value.low, Uint256(0, 0))
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=Uint256(2443, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack3.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2026, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2443{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value.low, Uint256(32, 0))
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem3 : StackItem = StackItem(value=stack2.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(32, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(2460, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack5.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2005, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2460{
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
    local newitem0 : StackItem = StackItem(value=stack3.value, next=stack7)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    return (stack=&newitem1, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment2470{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(2479, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2871, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2479{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=stack0.value.low, value=stack1.value)
    local memory_dict : DictAccess* = memory_dict
    return (stack=stack5, evm_pc=stack4.value, output=Output(0, cast(0, felt*), 0))
end

func segment2485{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=Uint256(2496, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack0.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2687, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2496{
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
    local newitem4 : StackItem = StackItem(value=Uint256(2506, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=stack0.value, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack3.value, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(2698, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2506{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack3.value.low, Uint256(32, 0))
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack5)
    local newitem1 : StackItem = StackItem(value=stack3.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack2.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack1.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(2522, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack1.value, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack0.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp0, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(2938, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2522{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(2531, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(3138, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2531{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value.low, stack0.value.low)
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack6)
    return (stack=&newitem0, evm_pc=stack5.value, output=Output(0, cast(0, felt*), 0))
end

func segment2542{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(2551, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2551{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=stack0.value.low, value=stack1.value)
    local memory_dict : DictAccess* = memory_dict
    return (stack=stack5, evm_pc=stack4.value, output=Output(0, cast(0, felt*), 0))
end

func segment2557{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(2566, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2925, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2566{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=stack0.value.low, value=stack1.value)
    local memory_dict : DictAccess* = memory_dict
    return (stack=stack5, evm_pc=stack4.value, output=Output(0, cast(0, felt*), 0))
end

func segment2572{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(stack0.value.low, Uint256(32, 0))
    let (local tmp1 : Uint256, _) = uint256_add(stack0.value.low, Uint256(0, 0))
    local newitem2 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(2593, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp1, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack1.value, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(2470, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2593{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2599{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(stack0.value.low, Uint256(32, 0))
    let (local tmp1 : Uint256) = uint256_sub(tmp0, stack0.value.low)
    let (local tmp2 : Uint256, _) = uint256_add(stack0.value.low, Uint256(0, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp2.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp2.low, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    local newitem2 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(2625, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp0, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack1.value, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(2485, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2625{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack5)
    return (stack=&newitem0, evm_pc=stack4.value, output=Output(0, cast(0, felt*), 0))
end

func segment2633{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(stack0.value.low, Uint256(32, 0))
    let (local tmp1 : Uint256, _) = uint256_add(stack0.value.low, Uint256(0, 0))
    local newitem2 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(2654, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp1, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack1.value, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(2542, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2654{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2660{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(stack0.value.low, Uint256(32, 0))
    let (local tmp1 : Uint256, _) = uint256_add(stack0.value.low, Uint256(0, 0))
    local newitem2 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(2681, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp1, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=stack1.value, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(2557, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2681{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2687{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, Uint256(0, 0).low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        Uint256(0, 0).low)
    local memory_dict : DictAccess* = memory_dict
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack3)
    return (stack=&newitem0, evm_pc=stack2.value, output=Output(0, cast(0, felt*), 0))
end

func segment2698{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack1.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=stack1.value.low, value=Uint256(0, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256, _) = uint256_add(stack1.value.low, Uint256(32, 0))
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2715{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=Uint256(2726, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack0.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2726{
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
    local newitem1 : StackItem = StackItem(value=stack0.value, next=stack3)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(2737, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack3.value, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(2915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2737{
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
    let (local tmp0 : Uint256) = uint256_sub(
        Uint256(340282366920938463463374607431768211455, 340282366920938463463374607431768211455),
        stack0.value.low)
    let (local tmp1 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack2.value.low, tmp0)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
        local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
        local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(2790, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(2789, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(3039, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2789{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2791, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2790{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack1.value.low, stack2.value.low)
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2801{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=Uint256(2812, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack0.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2812{
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
    local newitem1 : StackItem = StackItem(value=stack0.value, next=stack3)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(2823, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack3.value, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(2915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2823{
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
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(
        stack2.value.low, stack0.value.low)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
        local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
        local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(2842, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(2841, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(3039, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2841{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(2843, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2842{
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
    let (local tmp0 : Uint256) = uint256_sub(stack1.value.low, stack2.value.low)
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2853{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=Uint256(2864, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack0.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(2883, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2864{
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
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment2871{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value.low)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    local newitem0 : StackItem = StackItem(value=tmp1, next=stack2)
    return (stack=&newitem0, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment2883{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_and(
        stack0.value.low, Uint256(340282366920938463463374607431768211455, 4294967295))
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack2)
    return (stack=&newitem0, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment2915{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack2)
    return (stack=&newitem0, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment2925{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_and(stack0.value.low, Uint256(255, 0))
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack2)
    return (stack=&newitem0, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment2938{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(2942, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2941{
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
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(
        stack0.value.low, stack3.value.low)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(2968, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256, _) = uint256_add(stack1.value.low, stack0.value.low)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp2.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp2.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(stack2.value.low, stack0.value.low)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp4.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp4.low, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(stack0.value.low, Uint256(32, 0))
    local newitem3 : StackItem = StackItem(value=tmp5, next=stack1)
    return (stack=&newitem3, evm_pc=Uint256(2941, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2968{
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
    let (local tmp0 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(
        stack0.value.low, stack3.value.low)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(2983, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256, _) = uint256_add(stack2.value.low, stack3.value.low)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp2.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp2.low, value=Uint256(0, 0))
    local memory_dict : DictAccess* = memory_dict
    return (stack=stack0, evm_pc=Uint256(2984, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2983{
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
    return (stack=stack5, evm_pc=stack4.value, output=Output(0, cast(0, felt*), 0))
end

func segment2989{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256, _) = uint256_unsigned_div_rem(stack0.value.low, Uint256(2, 0))
    let (local tmp1 : Uint256) = uint256_and(stack0.value.low, Uint256(1, 0))
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
        local newitem2 : StackItem = StackItem(value=tmp1, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(3013, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = uint256_and(tmp0, Uint256(127, 0))
    local newitem1 : StackItem = StackItem(value=tmp2, next=stack0)
    local newitem2 : StackItem = StackItem(value=tmp1, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(3014, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3013{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(
        stack1.value.low, Uint256(32, 0))
    let (local tmp1 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(stack0.value.low, tmp0)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(3033, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(3032, 0), next=stack0)
    return (stack=&newitem2, evm_pc=Uint256(3086, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3032{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(3034, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3033{
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
    local newitem0 : StackItem = StackItem(value=stack1.value, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment3039{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=0, value=Uint256(0, 104056132734201558943083440019945291776))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 4, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=4, value=Uint256(17, 0))
    local memory_dict : DictAccess* = memory_dict
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3086{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=0, value=Uint256(0, 104056132734201558943083440019945291776))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 4, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=4, value=Uint256(34, 0))
    local memory_dict : DictAccess* = memory_dict
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3133{
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

func segment3138{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(stack0.value.low, Uint256(31, 0))
    let (local tmp1 : Uint256) = uint256_and(
        tmp0,
        Uint256(340282366920938463463374607431768211424, 340282366920938463463374607431768211455))
    local newitem0 : StackItem = StackItem(value=tmp1, next=stack2)
    return (stack=&newitem0, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment3155{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(3164, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2853, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3164{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        stack1.value.low, stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack1, evm_pc=Uint256(3175, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3175{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    return (stack=stack2, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
end

func segment3178{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem1 : StackItem = StackItem(value=Uint256(3187, 0), next=stack0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3187{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        stack1.value.low, stack0.value.low)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack1, evm_pc=Uint256(3198, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment3198{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    return (stack=stack2, evm_pc=stack1.value, output=Output(0, cast(0, felt*), 0))
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(89, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment89(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(144, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment144(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(149, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment149(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(170, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment170(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(175, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment175(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(177, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment177(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(189, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment189(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(211, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment211(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(220, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment220(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(232, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment232(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(254, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment254(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(259, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment259(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(272, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment272(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(281, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment281(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(293, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment293(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(302, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment302(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(315, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment315(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(324, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment324(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(336, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment336(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(345, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment345(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(358, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment358(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(367, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment367(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(388, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment388(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(393, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment393(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(395, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment395(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(407, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment407(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(429, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment429(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(434, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment434(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(447, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment447(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(456, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment456(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(468, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment468(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(490, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment490(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(495, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment495(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(508, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment508(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(529, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment529(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(538, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment538(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(551, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment551(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(560, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment560(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(572, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment572(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(594, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment594(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(599, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment599(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(612, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment612(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(621, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment621(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(700, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment700(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(711, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment711(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(724, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment724(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(768, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment768(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(802, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment802(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(816, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment816(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(853, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment853(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(995, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment995(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1001, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1001(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1020, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1020(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1099, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1099(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1110, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1110(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1328, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1328(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1470, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1470(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1610, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1610(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1618, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1618(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1697, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1697(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1783, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1783(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1802, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1802(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1826, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1826(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1839, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1839(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1883, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1883(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1917, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1917(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1931, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1931(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1960, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1960(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1968, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1968(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2005, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2005(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2020, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2020(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2026, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2026(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2041, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2041(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2047, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2047(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2068, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2068(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2069, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2069(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2083, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2083(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2092, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2092(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2114, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2114(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2115, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2115(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2129, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2129(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2146, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2146(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2156, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2156(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2181, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2181(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2182, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2182(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2196, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2196(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2213, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2213(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2230, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2230(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2247, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2247(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2259, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2259(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2281, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2281(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2282, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2282(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2296, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2296(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2313, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2313(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2323, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2323(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2347, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2347(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2348, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2348(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2362, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2362(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2379, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2379(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2396, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2396(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2406, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2406(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2428, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2428(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2429, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2429(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2443, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2443(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2460, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2460(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2470, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2470(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2479, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2479(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2485, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2485(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2496, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2496(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2506, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2506(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2522, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2522(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2531, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2531(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2542, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2542(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2551, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2551(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2557, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2557(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2566, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2566(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2572, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2572(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2593, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2593(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2599, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2599(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2625, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2625(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2633, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2633(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2654, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2654(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2660, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2660(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2681, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2681(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2687, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2687(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2698, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2698(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2715, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2715(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2726, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2726(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2737, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2737(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2789, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2789(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2790, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2790(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2801, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2801(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2812, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2812(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2823, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2823(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2841, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2841(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2842, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2842(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2853, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2853(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2864, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2864(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2871, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2871(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2883, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2883(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2915, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2915(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2925, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2925(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2938, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2938(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2941, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2941(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2968, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2968(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2983, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2983(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2989, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2989(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3013, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3013(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3032, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3032(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3033, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3033(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3039, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3039(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3086, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3086(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3133, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3133(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3138, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3138(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3155, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3155(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3164, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3164(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3175, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3175(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3178, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3178(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3187, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3187(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(3198, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment3198(exec_env, stack)
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

    let (local stack, local output) = run_from{
        storage_ptr=storage_ptr,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        msize=msize,
        memory_dict=memory_dict}(&exec_env, Uint256(0, 0), &stack0)

    return ()
end
