%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import split_felt, unsigned_div_rem
from starkware.cairo.common.pow import pow
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from evm.array import (
    array_copy_to_memory, array_create_from_memory, array_load, extend_array_to_len)
from evm.exec_env import ExecutionEnvironment
from evm.utils import felt_to_uint256, uint256_to_address_felt, update_msize

func caller{syscall_ptr : felt*, range_check_ptr}() -> (caller_data : Uint256):
    let (caller_address) = get_caller_address()
    let (res) = felt_to_uint256(caller_address)
    return (res)
end

func calldatacopy{
        memory_dict : DictAccess*, range_check_ptr, msize, exec_env : ExecutionEnvironment*}(
        dest_offset : Uint256, offset : Uint256, length : Uint256) -> ():
    alloc_locals
    let (local msize) = update_msize(msize, dest_offset.low, length.low)
    local memory_dict : DictAccess* = memory_dict
    array_copy_to_memory(
        exec_env.calldata_size, exec_env.calldata, dest_offset.low, offset.low, length.low)
    return ()
end

func calldatasize{range_check_ptr, exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.calldata_size, high=0))
end

func calldataload{range_check_ptr, exec_env : ExecutionEnvironment*}(offset : Uint256) -> (
        value : Uint256):
    let (value) = array_load(exec_env.calldata_size, exec_env.calldata, offset.low)
    return (value=value)
end

func returndata_copy{range_check_ptr, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*}(
        memory_pos : Uint256, returndata_pos : Uint256, length : Uint256):
    array_copy_to_memory(
        exec_env.returndata_len,
        exec_env.returndata,
        returndata_pos.low,
        memory_pos.low,
        length.low)
    return ()
end

# ######################### Making remote calls ###############################

@contract_interface
namespace GenericCallInterface:
    func fun_ENTRY_POINT(calldata_size : felt, calldata_len : felt, calldata : felt*) -> (
            success : felt, returndata_size : felt, returndata_len : felt, returndata : felt*):
    end
end

func calculate_data_len{range_check_ptr}(calldata_size) -> (calldata_len):
    let (calldata_len_, rem) = unsigned_div_rem(calldata_size, 16)
    if rem != 0:
        return (calldata_len=calldata_len_ + 1)
    else:
        return (calldata_len=calldata_len_)
    end
end

func warp_call{
        syscall_ptr : felt*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr}(
        gas : Uint256, address : Uint256, value : Uint256, in : Uint256, insize : Uint256,
        out : Uint256, outsize : Uint256) -> (success : Uint256):
    alloc_locals
    let (__fp__, _) = get_fp_and_pc()
    let (mem : felt*) = array_create_from_memory{
        memory_dict=memory_dict, range_check_ptr=range_check_ptr}(in.low, insize.low)
    let (calldata_len) = calculate_data_len(insize.low)
    let (address_felt : felt) = uint256_to_address_felt(address)
    let (success, returndata_size, returndata_len,
        returndata) = GenericCallInterface.fun_ENTRY_POINT(
        address_felt, insize.low, calldata_len, mem)
    array_copy_to_memory(returndata_size, returndata, 0, out.low, outsize.low)
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size,
        calldata_len=exec_env.calldata_len,
        calldata=exec_env.calldata,
        returndata_size=returndata_size,
        returndata_len=returndata_len,
        returndata=returndata,
        to_returndata_size=exec_env.to_returndata_size,
        to_returndata_len=exec_env.to_returndata_len,
        to_returndata=exec_env.to_returndata)
    let exec_env : ExecutionEnvironment* = &exec_env_
    return (Uint256(success, 0))
end

func warp_static_call{
        syscall_ptr : felt*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr}(
        gas : Uint256, address : Uint256, in : Uint256, insize : Uint256, out : Uint256,
        outsize : Uint256) -> (success : Uint256):
    return warp_call(gas, address, Uint256(0, 0), in, insize, out, outsize)
end

func returndata_write{memory_dict : DictAccess*, exec_env : ExecutionEnvironment*, range_check_ptr}(
        returndata_ptr : Uint256, returndata_size : Uint256):
    alloc_locals
    let (__fp__, _) = get_fp_and_pc()
    let (returndata : felt*) = array_create_from_memory(returndata_ptr.low, returndata_size.low)
    let (returndata_len) = calculate_data_len(returndata_size.low)
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size,
        calldata_len=exec_env.calldata_len,
        calldata=exec_env.calldata,
        returndata_size=exec_env.returndata_size,
        returndata_len=exec_env.returndata_len,
        returndata=exec_env.returndata,
        to_returndata_size=returndata_size.low,
        to_returndata_len=returndata_len,
        to_returndata=returndata)
    let exec_env : ExecutionEnvironment* = &exec_env_
    return ()
end
