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
    Uint256, uint256_add, uint256_and, uint256_eq, uint256_mul, uint256_not, uint256_shl,
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
        return (stack=stack0, evm_pc=Uint256(176, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = aload(exec_env.input_len, exec_env.input, 0)
    let (local tmp3 : Uint256) = uint256_shr(Uint256(224, 0), tmp2)
    let (local tmp4 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(
        Uint256(1206382372, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp4, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(105, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp5 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(
        Uint256(1889567281, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp5, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(78, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp6 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1889567281, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp6, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(466, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp7 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(2514000705, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp7, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(511, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp8 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(3714247998, 0), tmp3)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp8, Uint256(0, 0))
    if immediate == 0:
        local newitem0 : StackItem = StackItem(value=tmp3, next=stack0)
        return (stack=&newitem0, evm_pc=Uint256(532, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment78{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1206382372, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(415, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp1 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(1607020700, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(434, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment105{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(
        Uint256(309457050, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(154, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp1 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(309457050, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(245, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(404098525, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(335, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp3 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(826074471, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp3, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(371, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment154{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(16192718, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(181, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp1 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(
        Uint256(117300739, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(202, 0), output=Output(0, cast(0, felt*), 0))
    end
    return (stack=stack0, evm_pc=Uint256(177, 0), output=Output(0, cast(0, felt*), 0))
end

func segment176{
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

func segment181{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(200, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(195, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1363, 0), output=Output(0, cast(0, felt*), 0))
end

func segment195{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(588, 0), output=Output(0, cast(0, felt*), 0))
end

func segment200{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func segment202{
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
        return (stack=&newitem0, evm_pc=Uint256(214, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment214{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem0 : StackItem = StackItem(value=Uint256(223, 0), next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(637, 0), output=Output(0, cast(0, felt*), 0))
end

func segment223{
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
    local newitem0 : StackItem = StackItem(value=Uint256(236, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1398, 0), output=Output(0, cast(0, felt*), 0))
end

func segment236{
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
    let (local tmp1 : Uint256) = uint256_sub(stack0.value, tmp0)
    let (local output : Output) = create_from_memory(tmp0.low, tmp1.low)
    return (stack=stack1, evm_pc=Uint256(0, 0), output=output)
end

func segment245{
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
        return (stack=&newitem0, evm_pc=Uint256(257, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment257{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(319, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(272, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1303, 0), output=Output(0, cast(0, felt*), 0))
end

func segment272{
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
    let (local tmp0 : Uint256) = uint256_and(Uint256(319, 0), stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = uint256_and(Uint256(319, 0), stack2.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    s_store(low=tmp3.low, high=tmp3.high, value_low=stack1.value.low, value_high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment319{
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
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    local newitem0 : StackItem = StackItem(value=tmp3, next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(236, 0), output=Output(0, cast(0, felt*), 0))
end

func segment335{
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
        return (stack=&newitem0, evm_pc=Uint256(347, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment347{
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
    local newitem0 : StackItem = StackItem(value=Uint256(357, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=tmp0, next=&newitem0)
    return (stack=&newitem1, evm_pc=Uint256(357, 0), output=Output(0, cast(0, felt*), 0))
end

func segment357{
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
    local newitem0 : StackItem = StackItem(value=tmp1, next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(236, 0), output=Output(0, cast(0, felt*), 0))
end

func segment371{
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
        return (stack=&newitem0, evm_pc=Uint256(383, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment383{
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
    let (local tmp1 : Uint256) = uint256_and(Uint256(255, 0), tmp0)
    local newitem0 : StackItem = StackItem(value=Uint256(397, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    return (stack=&newitem1, evm_pc=Uint256(397, 0), output=Output(0, cast(0, felt*), 0))
end

func segment397{
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
    let (local tmp1 : Uint256) = uint256_and(stack0.value, Uint256(255, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp0.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp0.low, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256, _) = uint256_add(Uint256(32, 0), tmp0)
    local newitem0 : StackItem = StackItem(value=tmp2, next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(236, 0), output=Output(0, cast(0, felt*), 0))
end

func segment415{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(200, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(429, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1261, 0), output=Output(0, cast(0, felt*), 0))
end

func segment429{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(779, 0), output=Output(0, cast(0, felt*), 0))
end

func segment434{
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
        return (stack=&newitem0, evm_pc=Uint256(446, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment446{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(319, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(461, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1184, 0), output=Output(0, cast(0, felt*), 0))
end

func segment461{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    return (stack=stack0, evm_pc=Uint256(819, 0), output=Output(0, cast(0, felt*), 0))
end

func segment466{
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
        return (stack=&newitem0, evm_pc=Uint256(478, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment478{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(357, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(493, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1099, 0), output=Output(0, cast(0, felt*), 0))
end

func segment493{
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

func segment511{
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
        return (stack=&newitem0, evm_pc=Uint256(523, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment523{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local newitem0 : StackItem = StackItem(value=Uint256(223, 0), next=stack1)
    return (stack=&newitem0, evm_pc=Uint256(1058, 0), output=Output(0, cast(0, felt*), 0))
end

func segment532{
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
        return (stack=&newitem0, evm_pc=Uint256(544, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment544{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local tmp0 : Uint256 = Uint256(exec_env.calldata_size, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(357, 0), next=stack1)
    local newitem1 : StackItem = StackItem(value=Uint256(559, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1133, 0), output=Output(0, cast(0, felt*), 0))
end

func segment559{
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

func segment588{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_and(stack0.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = s_load(low=tmp1.low, high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem2 : StackItem = StackItem(value=stack1.value, next=stack0)
    local newitem3 : StackItem = StackItem(value=tmp1, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(628, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack1.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp2, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(1507, 0), output=Output(0, cast(0, felt*), 0))
end

func segment628{
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
        low=stack2.value.low,
        high=stack2.value.high,
        value_low=stack0.value.low,
        value_high=stack0.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack7, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment637{
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
    local newitem1 : StackItem = StackItem(value=Uint256(650, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1530, 0), output=Output(0, cast(0, felt*), 0))
end

func segment650{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256, _) = uint256_add(Uint256(31, 0), stack0.value)
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
    let (local tmp7 : Uint256) = s_load(low=stack1.value.low, high=stack1.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=tmp4, next=stack2)
    local newitem1 : StackItem = StackItem(value=stack1.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=tmp6, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack1.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(694, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp7, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(1530, 0), output=Output(0, cast(0, felt*), 0))
end

func segment694{
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
    let (local tmp0 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp0, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(771, 0), output=Output(0, cast(0, felt*), 0))
    end
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(
        Uint256(31, 0), stack0.value)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(728, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = s_load(low=stack1.value.low, high=stack1.value.high)
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
    let (local tmp5 : Uint256, _) = uint256_add(Uint256(32, 0), stack3.value)
    local newitem0 : StackItem = StackItem(value=tmp5, next=stack4)
    local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(771, 0), output=Output(0, cast(0, felt*), 0))
end

func segment728{
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
    return (stack=&newitem2, evm_pc=Uint256(743, 0), output=Output(0, cast(0, felt*), 0))
end

func segment742{
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
        return (stack=&newitem2, evm_pc=Uint256(742, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp4 : Uint256) = uint256_sub(tmp2, stack3.value)
    let (local tmp5 : Uint256) = uint256_and(Uint256(31, 0), tmp4)
    let (local tmp6 : Uint256, _) = uint256_add(stack3.value, tmp5)
    local newitem0 : StackItem = StackItem(value=tmp6, next=stack4)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(772, 0), output=Output(0, cast(0, felt*), 0))
end

func segment771{
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

func segment779{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_and(stack1.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = s_load(low=tmp1.low, high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack0)
    local newitem3 : StackItem = StackItem(value=tmp1, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(628, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=stack0.value, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=tmp2, next=&newitem6)
    return (stack=&newitem7, evm_pc=Uint256(1483, 0), output=Output(0, cast(0, felt*), 0))
end

func segment819{
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
    let (local tmp0 : Uint256) = uint256_and(Uint256(319, 0), stack0.value)
    let (local tmp1 : Uint256) = uint256_and(Uint256(319, 0), stack3.value)
    let (local tmp2 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(tmp1, tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem4, evm_pc=Uint256(957, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp3 : Uint256) = uint256_and(stack3.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp3)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256) = uint256_and(stack0.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp5)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp4)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp6 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256) = s_load(low=tmp6.low, high=tmp6.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp8 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack1.value, tmp7)
    let (local tmp9 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp8)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp9, Uint256(0, 0))
    if immediate == 0:
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem4, evm_pc=Uint256(896, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment896{
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
    let (local tmp0 : Uint256) = uint256_and(stack4.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(5, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = uint256_and(stack1.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp2)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=tmp1)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp3 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp4 : Uint256) = s_load(low=tmp3.low, high=tmp3.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem5 : StackItem = StackItem(value=stack2.value, next=stack0)
    local newitem6 : StackItem = StackItem(value=tmp3, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=Uint256(951, 0), next=&newitem7)
    local newitem9 : StackItem = StackItem(value=stack2.value, next=&newitem8)
    local newitem10 : StackItem = StackItem(value=tmp4, next=&newitem9)
    return (stack=&newitem10, evm_pc=Uint256(1507, 0), output=Output(0, cast(0, felt*), 0))
end

func segment951{
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
        low=stack2.value.low,
        high=stack2.value.high,
        value_low=stack0.value.low,
        value_high=stack0.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    return (stack=stack4, evm_pc=Uint256(958, 0), output=Output(0, cast(0, felt*), 0))
end

func segment957{
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
    let (local tmp0 : Uint256) = uint256_and(stack4.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = s_load(low=tmp1.low, high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem5 : StackItem = StackItem(value=stack2.value, next=stack0)
    local newitem6 : StackItem = StackItem(value=tmp1, next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=Uint256(997, 0), next=&newitem7)
    local newitem9 : StackItem = StackItem(value=stack2.value, next=&newitem8)
    local newitem10 : StackItem = StackItem(value=tmp2, next=&newitem9)
    return (stack=&newitem10, evm_pc=Uint256(1507, 0), output=Output(0, cast(0, felt*), 0))
end

func segment997{
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
        low=stack2.value.low,
        high=stack2.value.high,
        value_low=stack0.value.low,
        value_high=stack0.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    let (local tmp0 : Uint256) = uint256_and(stack7.value, Uint256(319, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 32, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=32, value=Uint256(4, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256) = sha(0, 64)
    local msize = msize
    local memory_dict : DictAccess* = memory_dict
    let (local tmp2 : Uint256) = s_load(low=tmp1.low, high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem4 : StackItem = StackItem(value=stack6.value, next=stack4)
    local newitem5 : StackItem = StackItem(value=tmp1, next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(1042, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=stack6.value, next=&newitem7)
    local newitem9 : StackItem = StackItem(value=tmp2, next=&newitem8)
    return (stack=&newitem9, evm_pc=Uint256(1483, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1042{
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
        low=stack2.value.low,
        high=stack2.value.high,
        value_low=stack0.value.low,
        value_high=stack0.value.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local newitem0 : StackItem = StackItem(value=Uint256(1, 0), next=stack10)
    return (stack=&newitem0, evm_pc=stack9.value, output=Output(0, cast(0, felt*), 0))
end

func segment1058{
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
    local newitem1 : StackItem = StackItem(value=Uint256(650, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1530, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1071{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, stack0.value.low)
    let (local tmp1 : Uint256) = uint256_and(tmp0, Uint256(319, 0))
    let (local tmp2 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(tmp0, tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
        return (stack=&newitem1, evm_pc=Uint256(1094, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1094{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack3)
    return (stack=&newitem0, evm_pc=stack2.value, output=Output(0, cast(0, felt*), 0))
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
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack0.value)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(32, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem2, evm_pc=Uint256(1117, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1117{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local newitem2 : StackItem = StackItem(value=Uint256(1126, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=stack1.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1126{
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

func segment1133{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack0.value)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(64, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        return (stack=&newitem3, evm_pc=Uint256(1152, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1152{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local newitem3 : StackItem = StackItem(value=Uint256(1161, 0), next=stack0)
    local newitem4 : StackItem = StackItem(value=stack2.value, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1161{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack3.value, Uint256(32, 0))
    local newitem1 : StackItem = StackItem(value=stack0.value, next=stack3)
    local newitem2 : StackItem = StackItem(value=stack1.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(1175, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp0, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1175{
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
    local newitem0 : StackItem = StackItem(value=stack2.value, next=stack6)
    local newitem1 : StackItem = StackItem(value=stack0.value, next=&newitem0)
    return (stack=&newitem1, evm_pc=stack5.value, output=Output(0, cast(0, felt*), 0))
end

func segment1184{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack0.value)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(128, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
        local newitem5 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem4)
        return (stack=&newitem5, evm_pc=Uint256(1206, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1206{
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
    local newitem5 : StackItem = StackItem(value=Uint256(1215, 0), next=stack0)
    local newitem6 : StackItem = StackItem(value=stack4.value, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1215{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack5.value, Uint256(32, 0))
    local newitem1 : StackItem = StackItem(value=stack0.value, next=stack5)
    local newitem2 : StackItem = StackItem(value=stack3.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack2.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack1.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(1229, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp0, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1229{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack5.value, Uint256(64, 0))
    let (local tmp1 : Uint256) = aload(exec_env.input_len, exec_env.input, tmp0.low)
    let (local tmp2 : Uint256, _) = uint256_add(stack5.value, Uint256(96, 0))
    local newitem2 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem3 : StackItem = StackItem(value=tmp1, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=stack1.value, next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(1250, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=tmp2, next=&newitem5)
    return (stack=&newitem6, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1250{
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
    local newitem2 : StackItem = StackItem(value=stack2.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack0.value, next=&newitem2)
    return (stack=&newitem3, evm_pc=stack7.value, output=Output(0, cast(0, felt*), 0))
end

func segment1261{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack0.value)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(64, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        return (stack=&newitem3, evm_pc=Uint256(1280, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1280{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local newitem3 : StackItem = StackItem(value=Uint256(1289, 0), next=stack0)
    local newitem4 : StackItem = StackItem(value=stack2.value, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1289{
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
    let (local tmp0 : Uint256, _) = uint256_add(Uint256(32, 0), stack3.value)
    let (local tmp1 : Uint256) = aload(exec_env.input_len, exec_env.input, tmp0.low)
    local newitem0 : StackItem = StackItem(value=stack0.value, next=stack6)
    local newitem1 : StackItem = StackItem(value=tmp1, next=&newitem0)
    return (stack=&newitem1, evm_pc=stack5.value, output=Output(0, cast(0, felt*), 0))
end

func segment1303{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack0.value)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(96, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
        return (stack=&newitem4, evm_pc=Uint256(1324, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1324{
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
    local newitem4 : StackItem = StackItem(value=Uint256(1333, 0), next=stack0)
    local newitem5 : StackItem = StackItem(value=stack3.value, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1333{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack4.value, Uint256(32, 0))
    let (local tmp1 : Uint256) = aload(exec_env.input_len, exec_env.input, tmp0.low)
    let (local tmp2 : Uint256, _) = uint256_add(stack4.value, Uint256(64, 0))
    local newitem1 : StackItem = StackItem(value=stack0.value, next=stack4)
    local newitem2 : StackItem = StackItem(value=tmp1, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=stack1.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(1354, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=tmp2, next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1354{
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
    local newitem1 : StackItem = StackItem(value=stack2.value, next=&newitem0)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    return (stack=&newitem2, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment1363{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack0.value)
    let (local tmp1 : Uint256) = slt{range_check_ptr=range_check_ptr}(tmp0, Uint256(64, 0))
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
        return (stack=&newitem3, evm_pc=Uint256(1382, 0), output=Output(0, cast(0, felt*), 0))
    end
    assert 0 = 1
    local item : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1382{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local tmp0 : Uint256) = aload(exec_env.input_len, exec_env.input, stack2.value.low)
    let (local tmp1 : Uint256, _) = uint256_add(stack2.value, Uint256(32, 0))
    local newitem1 : StackItem = StackItem(value=tmp0, next=stack2)
    local newitem2 : StackItem = StackItem(value=stack0.value, next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(1175, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp1, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1071, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1398{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, Uint256(32, 0).low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=Uint256(32, 0).low, value=Uint256(32, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, Uint256(0, 0).low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp0 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        Uint256(0, 0).low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp1 : Uint256, _) = uint256_add(stack2.value, stack0.value)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp1.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp1.low, value=tmp0)
    local memory_dict : DictAccess* = memory_dict
    local newitem3 : StackItem = StackItem(value=tmp0, next=stack0)
    local newitem4 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(1416, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1415{
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
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(stack0.value, stack1.value)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1443, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256, _) = uint256_add(stack0.value, stack5.value)
    let (local tmp3 : Uint256, _) = uint256_add(stack2.value, tmp2)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    let (local tmp4 : Uint256) = mload{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        tmp3.low)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp5 : Uint256, _) = uint256_add(stack0.value, stack4.value)
    let (local tmp6 : Uint256, _) = uint256_add(Uint256(64, 0), tmp5)
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp6.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=tmp6.low, value=tmp4)
    local memory_dict : DictAccess* = memory_dict
    let (local tmp7 : Uint256, _) = uint256_add(stack2.value, stack0.value)
    local newitem5 : StackItem = StackItem(value=tmp7, next=stack1)
    return (stack=&newitem5, evm_pc=Uint256(1415, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1443{
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
    let (local tmp0 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack0.value, stack1.value)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1461, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256, _) = uint256_add(stack4.value, stack1.value)
    let (local tmp3 : Uint256, _) = uint256_add(tmp2, Uint256(64, 0))
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, tmp3.low, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(
        offset=tmp3.low, value=Uint256(0, 0))
    local memory_dict : DictAccess* = memory_dict
    return (stack=stack0, evm_pc=Uint256(1462, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1461{
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
    let (local tmp0 : Uint256, _) = uint256_add(Uint256(31, 0), stack1.value)
    let (local tmp1 : Uint256) = uint256_and(
        Uint256(340282366920938463463374607431768211424, 340282366920938463463374607431768211455),
        tmp0)
    let (local tmp2 : Uint256, _) = uint256_add(tmp1, stack4.value)
    let (local tmp3 : Uint256, _) = uint256_add(Uint256(64, 0), tmp2)
    local newitem0 : StackItem = StackItem(value=tmp3, next=stack7)
    return (stack=&newitem0, evm_pc=stack6.value, output=Output(0, cast(0, felt*), 0))
end

func segment1483{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    let (local tmp0 : Uint256) = uint256_not(stack1.value)
    let (local tmp1 : Uint256) = is_gt{range_check_ptr=range_check_ptr}(stack0.value, tmp0)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem2, evm_pc=Uint256(1502, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(1502, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1589, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1502{
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
    let (local tmp0 : Uint256, _) = uint256_add(stack1.value, stack2.value)
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment1507{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local memory_dict : DictAccess* = memory_dict
    let (local tmp0 : Uint256) = is_lt{range_check_ptr=range_check_ptr}(stack0.value, stack1.value)
    let (local tmp1 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp0)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
        return (stack=&newitem2, evm_pc=Uint256(1525, 0), output=Output(0, cast(0, felt*), 0))
    end
    local newitem2 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem3 : StackItem = StackItem(value=Uint256(1525, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(1589, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1525{
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
    let (local tmp0 : Uint256) = uint256_sub(stack1.value, stack2.value)
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack4)
    return (stack=&newitem0, evm_pc=stack3.value, output=Output(0, cast(0, felt*), 0))
end

func segment1530{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    let (local tmp0 : Uint256) = uint256_shr(Uint256(1, 0), stack0.value)
    let (local tmp1 : Uint256) = uint256_and(stack0.value, Uint256(1, 0))
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp1, Uint256(0, 0))
    if immediate == 0:
        local newitem1 : StackItem = StackItem(value=tmp0, next=stack0)
        local newitem2 : StackItem = StackItem(value=tmp1, next=&newitem1)
        return (stack=&newitem2, evm_pc=Uint256(1550, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2 : Uint256) = uint256_and(tmp0, Uint256(127, 0))
    local newitem1 : StackItem = StackItem(value=tmp2, next=stack0)
    local newitem2 : StackItem = StackItem(value=tmp1, next=&newitem1)
    return (stack=&newitem2, evm_pc=Uint256(1551, 0), output=Output(0, cast(0, felt*), 0))
end

func segment1550{
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
        stack1.value, Uint256(32, 0))
    let (local tmp1 : Uint256) = is_eq{range_check_ptr=range_check_ptr}(stack0.value, tmp0)
    let (local tmp2 : Uint256) = is_zero{range_check_ptr=range_check_ptr}(tmp1)
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(tmp2, Uint256(0, 0))
    if immediate == 0:
        return (stack=stack0, evm_pc=Uint256(1583, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=Uint256(0, 0))
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

func segment1583{
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

func segment1589{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local msize) = update_msize{range_check_ptr=range_check_ptr}(msize, 0, 32)
    local memory_dict : DictAccess* = memory_dict
    local msize = msize
    mstore{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(offset=0, value=Uint256(0, 0))
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(78, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment78(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(105, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment105(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(154, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment154(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(176, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment176(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(181, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment181(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(195, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment195(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(200, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment200(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(202, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment202(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(214, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment214(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(236, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment236(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(245, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment245(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(257, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment257(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(319, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment319(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(335, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment335(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(347, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment347(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(357, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment357(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(371, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment371(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(383, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment383(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(397, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment397(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(415, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment415(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(446, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment446(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(461, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment461(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(466, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment466(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(478, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment478(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(493, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment493(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(511, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment511(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(523, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment523(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(532, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment532(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(544, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment544(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(559, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment559(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(588, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment588(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(628, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment628(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(637, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment637(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(650, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment650(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(694, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment694(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(728, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment728(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(742, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment742(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(771, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment771(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(779, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment779(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(819, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment819(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(896, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment896(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(951, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment951(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(957, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment957(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(997, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment997(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1042, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1042(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1058, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1058(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1071, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1071(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1094, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1094(exec_env, stack)
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
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1117, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1117(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1126, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1126(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1133, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1133(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1152, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1152(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1161, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1161(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1175, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1175(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1184, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1184(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1206, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1206(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1215, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1215(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1229, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1229(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1250, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1250(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1261, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1261(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1280, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1280(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1289, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1289(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1303, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1303(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1324, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1324(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1333, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1333(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1354, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1354(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1363, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1363(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1382, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1382(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1398, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1398(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1415, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1415(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1443, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1443(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1461, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1461(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1483, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1483(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1502, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1502(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1507, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1507(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1525, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1525(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1530, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1530(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1550, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1550(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1583, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1583(exec_env, stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(exec_env, evm_pc, stack)
    end
    let (immediate) = uint256_eq{range_check_ptr=range_check_ptr}(evm_pc, Uint256(1589, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment1589(exec_env, stack)
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
