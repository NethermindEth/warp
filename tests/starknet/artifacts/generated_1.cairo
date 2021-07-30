%lang starknet

%builtins pedersen range_check

from evm.memory import mstore
from evm.output import Output
from evm.stack import StackItem
from evm.uint256 import is_eq, is_gt, is_zero
from evm.utils import get_max, round_up_to_multiple, update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_and, uint256_eq, uint256_exp, uint256_sub, uint256_xor)
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
        memory_dict : DictAccess*}(stack : StackItem*, calldata : felt*, calldata_size) -> (
        stack : StackItem*, evm_pc : Uint256, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    s_store(low=0, high=0, value_low=78, value_high=0)
    s_store(low=1, high=0, value_low=113427455640312821154458202477256070485, value_high=1)
    s_store(low=2, high=0, value_low=49, value_high=0)
    s_store(low=3, high=0, value_low=21, value_high=0)
    s_store(low=4, high=0, value_low=46, value_high=0)
    s_store(low=5, high=0, value_low=0, value_high=0)
    s_store(low=6, high=0, value_low=1, value_high=0)
    s_store(low=7, high=0, value_low=16, value_high=0)
    s_store(low=8, high=0, value_low=0, value_high=0)
    s_store(low=9, high=0, value_low=1, value_high=0)
    s_store(low=10, high=0, value_low=1, value_high=0)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 128, 32)
    mstore(offset=128, value=Uint256(5252, 0))
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 160, 32)
    mstore(offset=160, value=Uint256(200, 0))
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local msize) = update_msize(msize, 128, 64)
    let (local immediate) = round_up_to_multiple(msize, 32)
    local tmp0 : Uint256 = Uint256(immediate, 0)
    s_store(low=11, high=0, value_low=tmp0.low, value_high=tmp0.high)
    return (stack=stack0, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
end

func run_from{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(
        evm_pc : Uint256, stack : StackItem*, calldata : felt*, calldata_size) -> (
        stack : StackItem*, output : Output):
    let (immediate) = uint256_eq(evm_pc, Uint256(0, 0))
    if immediate == 1:
        let (stack, evm_pc, output) = segment0(
            stack=stack, calldata=calldata, calldata_size=calldata_size)
        if output.active == 1:
            return (stack, output)
        end
        return run_from(evm_pc=evm_pc, stack=stack, calldata=calldata, calldata_size=calldata_size)
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
func main{storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        calldata_len : felt, calldata : felt*):
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
        memory_dict=memory_dict}(
        Uint256(0, 0), &stack0, calldata=calldata, calldata_size=calldata_len)

    return ()
end
