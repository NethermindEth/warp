%builtins output range_check

from evm import StackItem, is_lt, is_zero
from evm_utils.dict256 import dict256_new, dict256_read, dict256_write
from evm_utils.dict_access256 import DictAccess256
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_eq

func segment0{range_check_ptr}(memory_dict : DictAccess256*, stack : StackItem*) -> (
        memory_dict : DictAccess256*, stack : StackItem*, evm_pc : Uint256):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    return (memory_dict=memory_dict, stack=&newitem3, evm_pc=Uint256(19, 0))
end

func segment19{range_check_ptr}(memory_dict : DictAccess256*, stack : StackItem*) -> (
        memory_dict : DictAccess256*, stack : StackItem*, evm_pc : Uint256):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    let (local tmp0 : Uint256) = is_lt(stack0.value, stack4.value)
    let (local tmp1 : Uint256) = is_zero(tmp0)
    let (immediate) = uint256_eq(tmp1, Uint256(0, 0))
    if immediate == 0:
        return (memory_dict=memory_dict, stack=stack0, evm_pc=Uint256(52, 0))
    end
    let (local tmp2, _) = uint256_add(stack2.value, stack1.value)
    let (local tmp3, _) = uint256_add(Uint256(1, 0), stack0.value)
    local newitem2 : StackItem = StackItem(value=tmp2, next=stack3)
    local newitem3 : StackItem = StackItem(value=stack2.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp3, next=&newitem3)
    return (memory_dict=memory_dict, stack=&newitem4, evm_pc=Uint256(19, 0))
end

func segment52{range_check_ptr}(memory_dict : DictAccess256*, stack : StackItem*) -> (
        memory_dict : DictAccess256*, stack : StackItem*, evm_pc : Uint256):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local stack1 : StackItem* = stack0.next
    local stack2 : StackItem* = stack1.next
    local stack3 : StackItem* = stack2.next
    local stack4 : StackItem* = stack3.next
    local stack5 : StackItem* = stack4.next
    local stack6 : StackItem* = stack5.next
    if 1 == 1:
        return (memory_dict, stack, Uint256(-1, 0))
    end
    local newitem0 : StackItem = StackItem(value=stack2.value, next=stack6)
    return (memory_dict=memory_dict, stack=&newitem0, evm_pc=stack5.value)
end

func run_from{range_check_ptr}(
        memory_dict : DictAccess256*, evm_pc : Uint256, stack : StackItem*) -> (
        memory_dict : DictAccess256*, res : Uint256):
    let (immediate) = uint256_eq(evm_pc, Uint256(0, 0))
    if immediate == 1:
        let (memory_dict, stack, evm_pc) = segment0(memory_dict=memory_dict, stack=stack)
        return run_from(memory_dict, evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(19, 0))
    if immediate == 1:
        let (memory_dict, stack, evm_pc) = segment19(memory_dict=memory_dict, stack=stack)
        return run_from(memory_dict, evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(52, 0))
    if immediate == 1:
        let (memory_dict, stack, evm_pc) = segment52(memory_dict=memory_dict, stack=stack)
        return run_from(memory_dict, evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(-1, 0))
    if immediate == 1:
        let stack0 : StackItem* = stack
        return (memory_dict=memory_dict, res=stack0.value)
    end
    # Fail.
    assert 0 = 1
    jmp rel 0
end

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    let (local memory_dict : DictAccess256*) = dict256_new()
    local stack0 : StackItem
    assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.
    let (memory_dict, res) = run_from(memory_dict, Uint256(0, 0), &stack0)
    serialize_word(res.low)
    serialize_word(res.high)
    return ()
end

