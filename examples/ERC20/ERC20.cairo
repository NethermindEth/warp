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
from starkware.cairo.common.math_cmp import is_le
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
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp0, Uint256(4, 0))
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(163, 0), output=Output(0, cast(0, felt*), 0))
    end
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
    let (local tmp6 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(Uint256(117300739, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp6, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(223, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp7 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(Uint256(309457050, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp7, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(365, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp8 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(Uint256(404098525, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp8, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(486, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp9 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(Uint256(826074471, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp9, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(527, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp10 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1206382372, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp10, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(574, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp11 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1607020700, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp11, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(629, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp12 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1889567281, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp12, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(781, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp13 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(2514000705, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp13, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(858, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp14 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(3714247998, 0), tmp4)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp14, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(1000, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem0 : StackItem = StackItem(value=tmp4, next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(164, 0), output=Output(0, cast(0, felt*), 0))
end

func segment163{
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

func segment168{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp2 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp1)
    local newitem0 : StackItem = StackItem(value=Uint256(221, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp0, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1108, 0), output=Output(0, cast(0, felt*), 0))
end

func segment221{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment223{
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
        return (stack=stack0, evm_pc=Uint256(234, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment234{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(242, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(1267, 0), output=Output(0, cast(0, felt*), 0))
end

func segment242{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        stack0.value.low)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp1.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp1.low, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(Uint256(32, 0), tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp5 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        stack0.value.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(32, 0), stack0.value)
    local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp4, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp6, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp5, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp5, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp4, next=&newitem6)
    local newitem8 : StackItem = StackItem(value=tmp6, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(280, 0), output=Output(0, cast(0, felt*), 0))
end

func segment279{
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
        return (stack=stack0, evm_pc=Uint256(306, 0), output=Output(0, cast(0, felt*), 0))
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
    return (stack=&newitem3, evm_pc=Uint256(279, 0), output=Output(0, cast(0, felt*), 0))
end

func segment306{
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
        return (stack=&newitem1, evm_pc=Uint256(351, 0), output=Output(0, cast(0, felt*), 0))
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
    return (stack=&newitem1, evm_pc=Uint256(352, 0), output=Output(0, cast(0, felt*), 0))
end

func segment351{
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

func segment365{
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
        return (stack=stack0, evm_pc=Uint256(376, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment376{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp3 : Uint256) = aload(exec_env.input_len, exec_env.input, 68)
    let (local tmp4 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp3)
    local newitem0 : StackItem = StackItem(value=Uint256(460, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp4, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1425, 0), output=Output(0, cast(0, felt*), 0))
end

func segment460{
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

func segment486{
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
        return (stack=stack0, evm_pc=Uint256(497, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment497{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(505, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(1567, 0), output=Output(0, cast(0, felt*), 0))
end

func segment505{
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

func segment527{
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
        return (stack=stack0, evm_pc=Uint256(538, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment538{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(546, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(1573, 0), output=Output(0, cast(0, felt*), 0))
end

func segment546{
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

func segment574{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    local newitem0 : StackItem = StackItem(value=Uint256(627, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1592, 0), output=Output(0, cast(0, felt*), 0))
end

func segment627{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment629{
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
        return (stack=stack0, evm_pc=Uint256(640, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment640{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp3 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp2)
    let (local tmp4 : Uint256) = aload(exec_env.input_len, exec_env.input, 68)
    let (local tmp5 : Uint256) = aload(exec_env.input_len, exec_env.input, 100)
    let (local tmp6 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp5)
    local newitem0 : StackItem = StackItem(value=Uint256(755, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp3, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp4, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp6, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1673, 0), output=Output(0, cast(0, felt*), 0))
end

func segment755{
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

func segment781{
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
        return (stack=stack0, evm_pc=Uint256(792, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment792{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    local newitem0 : StackItem = StackItem(value=Uint256(836, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    return (stack=&newitem1, evm_pc=Uint256(2250, 0), output=Output(0, cast(0, felt*), 0))
end

func segment836{
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

func segment858{
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
        return (stack=stack0, evm_pc=Uint256(869, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment869{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(877, 0), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(2274, 0), output=Output(0, cast(0, felt*), 0))
end

func segment877{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp3 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        stack0.value.low)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp1.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp1.low, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256, _) = uint256_add(Uint256(32, 0), tmp1)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp5 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        stack0.value.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(32, 0), stack0.value)
    local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp4, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp6, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp5, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp5, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp4, next=&newitem6)
    local newitem8 : StackItem = StackItem(value=tmp6, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(915, 0), output=Output(0, cast(0, felt*), 0))
end

func segment914{
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
        return (stack=stack0, evm_pc=Uint256(941, 0), output=Output(0, cast(0, felt*), 0))
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
    return (stack=&newitem3, evm_pc=Uint256(914, 0), output=Output(0, cast(0, felt*), 0))
end

func segment941{
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
        return (stack=&newitem1, evm_pc=Uint256(986, 0), output=Output(0, cast(0, felt*), 0))
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
    return (stack=&newitem1, evm_pc=Uint256(987, 0), output=Output(0, cast(0, felt*), 0))
end

func segment986{
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

func segment1000{
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
        return (stack=stack0, evm_pc=Uint256(1011, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1011{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, 4)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp0)
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 36)
    let (local tmp3 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211455, 4294967295), tmp2)
    local newitem0 : StackItem = StackItem(value=Uint256(1086, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp3, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2432, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1086{
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

func segment1108{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
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
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp3, stack1.value)
    let (local tmp5 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp4)
    let (local tmp6 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp5)
    let (local tmp7 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp6)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp7, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1186, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1186{
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

func segment1267{
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
        return (stack=&newitem5, evm_pc=Uint256(1417, 0), output=Output(0, cast(0, felt*), 0))
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
        return (stack=&newitem5, evm_pc=Uint256(1374, 0), output=Output(0, cast(0, felt*), 0))
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
    return (stack=&newitem5, evm_pc=Uint256(1417, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1374{
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
    return (stack=&newitem2, evm_pc=Uint256(1389, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1388{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256) = s_load(low=stack1.value.low, high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=stack0.value.low, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(1, 0), stack1.value)
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), stack0.value)
    let (local tmp3 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack2.value, tmp2)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp1, next=stack2)
        local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(1388, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack2.value)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack2.value, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack3)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack2.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1418, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1417{
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

func segment1425{
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

func segment1567{
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

func segment1573{
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

func segment1592{
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

func segment1673{
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
        return (stack=&newitem4, evm_pc=Uint256(2084, 0), output=Output(0, cast(0, felt*), 0))
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
    local memory_dict : DictAccess* = memory_dict
    let (local tmp12 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp11, stack1.value)
    let (local tmp13 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp12)
    let (local tmp14 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp13)
    let (local tmp15 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp14)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp15, Uint256(0, 0))
    if immediate == 0:
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem4, evm_pc=Uint256(1867, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1867{
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
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = s_load(low=tmp2.low, high=tmp2.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(tmp3, stack2.value)
    let (local tmp5 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp4)
    let (local tmp6 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp5)
    let (local tmp7 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp6)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp7, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1945, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1945{
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
    return (stack=stack0, evm_pc=Uint256(2085, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2084{
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

func segment2250{
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

func segment2274{
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
        return (stack=&newitem5, evm_pc=Uint256(2424, 0), output=Output(0, cast(0, felt*), 0))
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
        return (stack=&newitem5, evm_pc=Uint256(2381, 0), output=Output(0, cast(0, felt*), 0))
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
    return (stack=&newitem5, evm_pc=Uint256(2424, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2381{
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
    return (stack=&newitem2, evm_pc=Uint256(2396, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2395{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256) = s_load(low=stack1.value.low, high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, stack0.value.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=stack0.value.low, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(Uint256(1, 0), stack1.value)
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), stack0.value)
    let (local tmp3 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack2.value, tmp2)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp1, next=stack2)
        local newitem2 : StackItem = StackItem(value=tmp2, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(2395, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack2.value)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack2.value, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack3)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack2.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(2425, 0), output=Output(0, cast(0, felt*), 0))
end

func segment2424{
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

func segment2432{
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(163, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment163(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(168, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment168(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(221, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment221(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(223, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment223(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(234, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment234(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(242, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment242(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(279, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment279(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(306, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment306(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(351, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment351(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(365, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment365(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(376, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment376(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(460, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment460(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(486, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment486(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(497, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment497(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(505, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment505(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(527, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment527(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(546, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment546(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(574, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment574(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(627, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment627(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(629, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment629(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(640, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment640(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(755, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment755(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(781, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment781(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(792, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment792(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(836, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment836(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(858, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment858(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(869, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment869(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(877, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment877(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(914, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment914(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(941, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment941(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(986, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment986(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1000, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1000(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1011, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1011(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1086, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1086(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1108, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1108(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1186, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1186(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1267, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1267(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1374, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1374(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1388, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1388(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1417, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1417(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1425, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1425(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1567, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1567(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1573, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1573(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1592, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1592(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1673, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1673(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1867, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1867(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1945, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1945(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2084, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2084(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2250, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2250(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2274, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2274(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2381, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2381(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2395, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2395(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2424, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2424(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(2432, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment2432(exec_env, stack)
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
