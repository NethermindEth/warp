%lang starknet

%builtins pedersen range_check

from evm.array import create_from_memory
from evm.output import Output
from evm.stack import StackItem
from evm.utils import update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.starknet.common.storage import Storage

func segment0{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(stack : StackItem*) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()

    let (local msize) = update_msize(msize, 0, 32)
    let (local memval) = create_from_memory(0, 32)
    local high
    local low
    %{
        from Crypto.Hash import keccak

        keccak_hash = keccak.new(digest_bits=256)
        arr = []
        arr_length = 32//16 if 32 % 16 == 0 else 32//16+1
        for i in range(arr_length):
            arr.append(memory[ids.memval+i])

        keccak_input = bytearray()
        for i in range(arr_length-1):
            keccak_input += arr[i].to_bytes(16,"big")
        keccak_input += arr[-1].to_bytes(16,"big") if 32%16 == 0 else arr[-1].to_bytes(32%16,"big")

        keccak_hash.update(keccak_input)
        hashed = keccak_hash.digest()
        ids.high = int.from_bytes(hashed[:16],"big")
        ids.low = int.from_bytes(hashed[16:32],"big")
    %}
    local tmp0 : Uint256 = Uint256(low, high)

    local newitem0 : StackItem = StackItem(value=tmp0, next=stack0)
    return (stack=&newitem0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func run_from{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(evm_pc : Uint256, stack : StackItem*) -> (
        stack : StackItem*, output : Output):
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

@external
func main{storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()

    let (local memory_dict : DictAccess*) = default_dict_new(0)
    local memory_start : DictAccess* = memory_dict

    tempvar msize = 0

    local stack0 : StackItem
    assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.

    let (local res, local output) = run_from{
        storage_ptr=storage_ptr,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        msize=msize,
        memory_dict=memory_dict}(Uint256(0, 0), &stack0)

    return ()
end

