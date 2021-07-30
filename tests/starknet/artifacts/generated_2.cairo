%lang starknet

%builtins pedersen range_check

from evm.memory import mload, mstore
from evm.output import Output
from evm.stack import StackItem
from evm.uint256 import is_lt, sgt, slt
from evm.utils import get_max, round_up_to_multiple, update_msize
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_eq, uint256_mul, uint256_not, uint256_or, uint256_shl)
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
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (local msize) = update_msize(msize, 128, 0)
    let (local immediate) = round_up_to_multiple(msize, 32)
    local tmp0 : Uint256 = Uint256(immediate, 0)
    s_store(low=0, high=0, value_low=tmp0.low, value_high=tmp0.high)
    s_store(low=1, high=0, value_low=0, value_high=0)
    s_store(low=2, high=0, value_low=1, value_high=0)
    let (local immediate) = round_up_to_multiple(msize, 32)
    local tmp1 : Uint256 = Uint256(immediate, 0)
    s_store(low=3, high=0, value_low=tmp1.low, value_high=tmp1.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 2, 32)
    mstore(offset=2, value=Uint256(13486, 0))
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 2, 32)
    let (local tmp2 : Uint256) = mload(2)
    let (local immediate) = round_up_to_multiple(msize, 32)
    local tmp3 : Uint256 = Uint256(immediate, 0)
    s_store(low=4, high=0, value_low=tmp3.low, value_high=tmp3.high)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 0, 32)
    mstore(offset=0, value=Uint256(48, 0))
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 2, 32)
    mstore(offset=2, value=Uint256(48098712, 0))
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local memory_dict : DictAccess* = memory_dict
    local storage_ptr : Storage* = storage_ptr
    let (local msize) = update_msize(msize, 2, 32)
    let (local tmp4 : Uint256) = mload(2)
    s_store(low=5, high=0, value_low=tmp4.low, value_high=tmp4.high)
    s_store(low=6, high=0, value_low=688, value_high=0)
    s_store(
        low=7,
        high=0,
        value_low=340282366920938463463374607431768211452,
        value_high=340282366920938463463374607431768211455)
    s_store(low=8, high=0, value_low=47, value_high=0)
    s_store(low=9, high=0, value_low=0, value_high=0)
    s_store(low=10, high=0, value_low=50465865728, value_high=0)
    s_store(low=11, high=0, value_low=1, value_high=0)
    s_store(low=12, high=0, value_low=0, value_high=0)
    s_store(low=13, high=0, value_low=27670116110564327424, value_high=0)
    local newitem0 : StackItem = StackItem(value=Uint256(13, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(0, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem1)
    local newitem3 : StackItem = StackItem(value=Uint256(1, 0), next=&newitem2)
    local newitem4 : StackItem = StackItem(value=Uint256(128, 0), next=&newitem3)
    local newitem5 : StackItem = StackItem(value=Uint256(5, 0), next=&newitem4)
    return (stack=&newitem5, evm_pc=Uint256(0, 0), output=Output(1, cast(0, felt*), 0))
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
