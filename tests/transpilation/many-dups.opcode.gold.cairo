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
    local newitem0 : StackItem = StackItem(value=Uint256(0, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=Uint256(2, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(3, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(5, 0), next=&newitem4)
    local newitem6 : StackItem = StackItem(value=Uint256(6, 0), next=&newitem5)
    local newitem7 : StackItem = StackItem(value=Uint256(7, 0), next=&newitem6)
    local newitem8 : StackItem = StackItem(value=Uint256(8, 0), next=&newitem7)
    local newitem9 : StackItem = StackItem(value=Uint256(9, 0), next=&newitem8)
    local newitem10 : StackItem = StackItem(value=Uint256(10, 0), next=&newitem9)
    local newitem11 : StackItem = StackItem(value=Uint256(11, 0), next=&newitem10)
    local newitem12 : StackItem = StackItem(value=Uint256(12, 0), next=&newitem11)
    local newitem13 : StackItem = StackItem(value=Uint256(13, 0), next=&newitem12)
    local newitem14 : StackItem = StackItem(value=Uint256(14, 0), next=&newitem13)
    local newitem15 : StackItem = StackItem(value=Uint256(15, 0), next=&newitem14)
    local newitem16 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem15)
    local newitem17 : StackItem = StackItem(value=Uint256(2, 0), next=&newitem16)
    local newitem18 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem17)
    local newitem19 : StackItem = StackItem(value=Uint256(6, 0), next=&newitem18)
    local newitem20 : StackItem = StackItem(value=Uint256(8, 0), next=&newitem19)
    local newitem21 : StackItem = StackItem(value=Uint256(10, 0), next=&newitem20)
    local newitem22 : StackItem = StackItem(value=Uint256(12, 0), next=&newitem21)
    local newitem23 : StackItem = StackItem(value=Uint256(14, 0), next=&newitem22)
    local newitem24 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem23)
    local newitem25 : StackItem = StackItem(value=Uint256(4, 0), next=&newitem24)
    local newitem26 : StackItem = StackItem(value=Uint256(8, 0), next=&newitem25)
    local newitem27 : StackItem = StackItem(value=Uint256(12, 0), next=&newitem26)
    local newitem28 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem27)
    local newitem29 : StackItem = StackItem(value=Uint256(8, 0), next=&newitem28)
    local newitem30 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem29)
    local newitem31 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem30)
    return (stack=&newitem31, evm_pc=Uint256(-1, 0))
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

