# This module is for functions that correspond to Yul builtin
# instructions. All such functions must take only Uint256's as
# explicit parameters and return tuples of Uint256's. Furthermore,
# they must be named just like their Yul counterparts. This way we
# ensure that they don't clash with some other names in the translated
# yul code. In case such naming conflicts with Cairo's keywords or
# builtin functions, the name should also be prefixed with "warp_".

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_label_location
from starkware.starknet.common.syscalls import (
    call_contract, delegate_call, emit_event, get_block_number, get_block_timestamp,
    get_contract_address)

from evm.array import array_create_from_memory
from evm.calls import general_call, returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.uint256 import Uint256
from evm.utils import ceil_div, felt_to_uint256, uint256_to_address_felt

func address{syscall_ptr : felt*, range_check_ptr}() -> (contract_address : Uint256):
    let (felt_address) = get_contract_address()
    let (uint_address) = felt_to_uint256(felt_address)
    return (uint_address)
end

func timestamp{syscall_ptr : felt*}() -> (res : Uint256):
    let (stamp) = get_block_timestamp()
    return (res=Uint256(stamp, 0))
end

func block_number{syscall_ptr : felt*}() -> (res : Uint256):
    let (number) = get_block_number()
    return (res=Uint256(number, 0))
end

func warp_return{
        memory_dict : DictAccess*, exec_env : ExecutionEnvironment*, range_check_ptr,
        termination_token, bitwise_ptr : BitwiseBuiltin*}(
        returndata_ptr : Uint256, returndata_size : Uint256):
    alloc_locals
    let termination_token = 1
    returndata_write(returndata_ptr.low, returndata_size.low)
    return ()
end

func warp_call{
        syscall_ptr : felt*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        gas : Uint256, address : Uint256, value : Uint256, in_offset : Uint256, in_size : Uint256,
        out_offset : Uint256, out_size : Uint256) -> (success : Uint256):
    let (call_function) = get_label_location(call_contract)
    let (address_felt) = uint256_to_address_felt(address)
    let (success) = general_call(
        call_function, address_felt, in_offset.low, in_size.low, out_offset.low, out_size.low)
    return (Uint256(success, 0))
end

func staticcall{
        syscall_ptr : felt*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        gas : Uint256, address : Uint256, in_offset : Uint256, in_size : Uint256,
        out_offset : Uint256, out_size : Uint256) -> (success : Uint256):
    return warp_call(gas, address, Uint256(0, 0), in_offset, in_size, out_offset, out_size)
end

func delegatecall{
        syscall_ptr : felt*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        gas : Uint256, address : Uint256, in_offset : Uint256, in_size : Uint256,
        out_offset : Uint256, out_size : Uint256) -> (success : Uint256):
    let (call_function) = get_label_location(delegate_call)
    let (address_felt) = uint256_to_address_felt(address)
    let (success) = general_call(
        call_function, address_felt, in_offset.low, in_size.low, out_offset.low, out_size.low)
    return (Uint256(success, 0))
end

func log0{syscall_ptr : felt*}(mem_offset : Uint256, mem_len : Uint256):
    let (key) = alloc()
    let (data) = array_create_from_memory(mem_offset.low, mem_len.low)
    let (data_len) = ceil_div(mem_len.low, 16)
    emit_event(keys_len=0, keys=key, data_len=data_len, data=data)
    return ()
end

func log1{
        syscall_ptr : felt*, memory_dict : DictAccess*, range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*}(mem_offset : Uint256, mem_len : Uint256, t1 : Uint256):
    alloc_locals
    let (local keys : felt*) = alloc()
    assert keys[0] = t1.low
    assert keys[1] = t1.high
    let (data) = array_create_from_memory(mem_offset.low, mem_len.low)
    let (data_len) = ceil_div(mem_len.low, 16)
    emit_event(keys_len=2, keys=keys, data_len=data_len, data=data)
    return ()
end

func log2{
        syscall_ptr : felt*, memory_dict : DictAccess*, range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*}(
        mem_offset : Uint256, mem_len : Uint256, t1 : Uint256, t2 : Uint256):
    alloc_locals
    let (local keys : felt*) = alloc()
    assert keys[0] = t1.low
    assert keys[1] = t1.high
    assert keys[2] = t2.low
    assert keys[3] = t2.high
    let (data) = array_create_from_memory(mem_offset.low, mem_len.low)
    let (data_len) = ceil_div(mem_len.low, 16)
    emit_event(keys_len=4, keys=keys, data_len=data_len, data=data)
    return ()
end

func log3{
        syscall_ptr : felt*, memory_dict : DictAccess*, range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*}(
        mem_offset : Uint256, mem_len : Uint256, t1 : Uint256, t2 : Uint256, t3 : Uint256):
    alloc_locals
    let (local keys : felt*) = alloc()
    assert keys[0] = t1.low
    assert keys[1] = t1.high
    assert keys[2] = t2.low
    assert keys[3] = t2.high
    assert keys[4] = t3.low
    assert keys[5] = t3.high
    let (data) = array_create_from_memory(mem_offset.low, mem_len.low)
    let (data_len) = ceil_div(mem_len.low, 16)
    emit_event(keys_len=6, keys=keys, data_len=data_len, data=data)
    return ()
end

func log4{
        syscall_ptr : felt*, memory_dict : DictAccess*, range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*}(
        mem_offset : Uint256, mem_len : Uint256, t1 : Uint256, t2 : Uint256, t3 : Uint256,
        t4 : Uint256):
    alloc_locals
    let (local keys : felt*) = alloc()
    assert keys[0] = t1.low
    assert keys[1] = t1.high
    assert keys[2] = t2.low
    assert keys[3] = t2.high
    assert keys[4] = t3.low
    assert keys[5] = t3.high
    assert keys[6] = t4.low
    assert keys[7] = t4.high
    let (data) = array_create_from_memory(mem_offset.low, mem_len.low)
    let (data_len) = ceil_div(mem_len.low, 16)
    emit_event(keys_len=8, keys=keys, data_len=data_len, data=data)
    return ()
end
