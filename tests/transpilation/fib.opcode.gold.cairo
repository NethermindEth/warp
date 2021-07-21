%builtins output range_check

from evm.output import Output, serialize_output
from evm.stack import StackItem
from evm.uint256 import is_lt, is_zero
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_eq

func segment0{range_check_ptr, msize, memory_dict : DictAccess*}(stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem2)
    return (stack=&newitem3, evm_pc=Uint256(19, 0), output=Output(0, cast(0, felt*), 0))
end

func segment19{range_check_ptr, msize, memory_dict : DictAccess*}(stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
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
        return (stack=stack0, evm_pc=Uint256(52, 0), output=Output(0, cast(0, felt*), 0))
    end
    let (local tmp2, _) = uint256_add(stack2.value, stack1.value)
    let (local tmp3, _) = uint256_add(Uint256(1, 0), stack0.value)
    local newitem2 : StackItem = StackItem(value=tmp2, next=stack3)
    local newitem3 : StackItem = StackItem(value=stack2.value, next=&newitem2)
    local newitem4 : StackItem = StackItem(value=tmp3, next=&newitem3)
    return (stack=&newitem4, evm_pc=Uint256(19, 0), output=Output(0, cast(0, felt*), 0))
end

func segment52{range_check_ptr, msize, memory_dict : DictAccess*}(stack : StackItem*) -> (
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
    return (stack=&newitem0, evm_pc=stack5.value, output=Output(0, cast(0, felt*), 0))
end

func run_from{range_check_ptr, msize, memory_dict : DictAccess*}(
        evm_pc : Uint256, stack : StackItem*) -> (stack : StackItem*, output : Output):
    let (immediate) = uint256_eq(evm_pc, Uint256(0, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment0(stack=stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(19, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment19(stack=stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(52, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment52(stack=stack)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(-1, 0))
    if immediate == 1:
        return (stack, Output(1, cast(0, felt*), 0))
    end
    # Fail.
    assert 0 = 1
    jmp rel 0
end

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()

    let (local memory_dict : DictAccess*) = default_dict_new(0)
    local memory_start : DictAccess* = memory_dict

    tempvar msize = 0

    local stack0 : StackItem
    assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.

    let (local stack, local output) = run_from{msize=msize, memory_dict=memory_dict}(
        Uint256(0, 0), &stack0)

    default_dict_finalize(memory_start, memory_dict, 0)
    local range_check_ptr = range_check_ptr
    serialize_word(stack.value.low)
    serialize_word(stack.value.high)
    serialize_output(output)
    return ()
end

