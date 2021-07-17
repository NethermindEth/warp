%builtins output range_check

from evm.stack import StackItem
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256, uint256_eq

func segment0{range_check_ptr, msize, memory_dict : DictAccess*}(stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    local newitem0 : StackItem = StackItem(value=Uint256(113427455640312821154458202477256070485, 1), next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(-1, 0))
end

func run_from{range_check_ptr, msize, memory_dict : DictAccess*}(
        evm_pc : Uint256, stack : StackItem*) -> (res : Uint256):
    let (immediate) = uint256_eq(evm_pc, Uint256(0, 0))
    if immediate == 1:
        let (stack, evm_pc) = segment0(stack=stack)
        return run_from(evm_pc=evm_pc, stack=stack)
    end
    let (immediate) = uint256_eq(evm_pc, Uint256(-1, 0))
    if immediate == 1:
        let stack0 : StackItem* = stack
        return (res=stack0.value)
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

    let (local res) = run_from{msize=msize, memory_dict=memory_dict}(Uint256(0, 0), &stack0)
    default_dict_finalize(memory_start, memory_dict, 0)

    serialize_word(res.low)
    serialize_word(res.high)
    return ()
end

