%builtins output range_check

from evm.memory import mstore
from evm.output import Output, serialize_output
from evm.stack import StackItem
from evm.utils import round_up_to_multiple, update_msize
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256, uint256_eq

func segment0{range_check_ptr, msize, memory_dict : DictAccess*}(stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local msize) = update_msize(msize, 128, 32)
    mstore(offset=128, value=Uint256(5252, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize(msize, 160, 32)
    mstore(offset=160, value=Uint256(200, 0))
    local memory_dict : DictAccess* = memory_dict
    let (local msize) = update_msize(msize, 128, 64)
    let (immediate) = round_up_to_multiple(msize, 32)
    local tmp0 : Uint256 = Uint256(immediate, 0)
    local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
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

