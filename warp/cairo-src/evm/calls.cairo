from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from evm.array import (
    array_copy_from_memory, array_copy_to_memory, array_create_from_memory, array_load,
    validate_array)
from evm.exec_env import ExecutionEnvironment
from evm.utils import ceil_div, felt_to_uint256, get_max, update_msize

func caller{syscall_ptr : felt*, range_check_ptr}() -> (caller_data : Uint256):
    let (caller_address) = get_caller_address()
    let (res) = felt_to_uint256(caller_address)
    return (res)
end

func calldatacopy{
        memory_dict : DictAccess*, range_check_ptr, msize, exec_env : ExecutionEnvironment*,
        bitwise_ptr : BitwiseBuiltin*}(dest_offset : Uint256, offset : Uint256, size : Uint256) -> (
        ):
    alloc_locals
    let (msize) = update_msize(msize, dest_offset.low, size.low)
    array_copy_to_memory(
        exec_env.calldata_len, exec_env.calldata, offset.low + 12, dest_offset.low, size.low)
    return ()
end

func calldatasize{range_check_ptr, exec_env : ExecutionEnvironment*}() -> (res : Uint256):
    return (Uint256(low=exec_env.calldata_size - 12, high=0))
end

func calldataload{range_check_ptr, exec_env : ExecutionEnvironment*, bitwise_ptr : BitwiseBuiltin*}(
        offset : Uint256) -> (value : Uint256):
    let (value) = array_load(exec_env.calldata_len, exec_env.calldata, offset.low + 12)
    return (value=value)
end

func returndata_copy{
        range_check_ptr, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        bitwise_ptr : BitwiseBuiltin*}(
        memory_pos : Uint256, returndata_pos : Uint256, size : Uint256):
    array_copy_to_memory(
        exec_env.returndata_len, exec_env.returndata, returndata_pos.low, memory_pos.low, size.low)
    return ()
end

# ######################### Making remote calls ###############################

# get_selector_from_name('__main')
const main_selector = 0x1b999a79a454af1c08c7c350b2dcee00593e13477465ce7e83f9b73d4c4ab98

func calldata_copy_from_memory{
        memory_dict : DictAccess*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        offset, size, array : felt*):
    alloc_locals
    let (primary_size) = get_max(0, size - 4)
    let (initial) = alloc()
    array_copy_from_memory(offset, size - primary_size, initial)
    assert array[0] = initial[0] / 256 ** 12
    array_copy_from_memory(offset + 4, primary_size, array + 1)
    return ()
end

func general_call{
        syscall_ptr : felt*, exec_env : ExecutionEnvironment*, memory_dict : DictAccess*,
        range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        call_function, address, in_offset, in_size, out_offset, out_size) -> (success):
    alloc_locals
    let (__fp__, _) = get_fp_and_pc()
    let (in_len) = ceil_div(in_size + 12, 16)
    let (cairo_calldata) = alloc()
    assert cairo_calldata[0] = in_size + 12
    assert cairo_calldata[1] = in_len
    calldata_copy_from_memory(in_offset, in_size, cairo_calldata + 2)

    [ap] = syscall_ptr; ap++
    [ap] = address; ap++
    [ap] = main_selector; ap++
    [ap] = 2 + in_len; ap++
    [ap] = cairo_calldata; ap++
    call abs call_function
    let syscall_ptr = cast([ap - 3], felt*)
    let cairo_retdata_size = [ap - 2]
    let cairo_retdata = cast([ap - 1], felt*)

    let returndata_size = cairo_retdata[0]
    let returndata_len = cairo_retdata[1]
    let returndata = cairo_retdata + 2
    assert cairo_retdata_size = returndata_len + 2

    validate_array(returndata_size, returndata_len, returndata)
    array_copy_to_memory(returndata_len, returndata, 0, out_offset, out_size)
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
    return (1)
end

func returndata_write{
        memory_dict : DictAccess*, exec_env : ExecutionEnvironment*, range_check_ptr,
        bitwise_ptr : BitwiseBuiltin*}(returndata_ptr, returndata_size):
    alloc_locals
    let (__fp__, _) = get_fp_and_pc()
    let (returndata : felt*) = array_create_from_memory(returndata_ptr, returndata_size)
    let (returndata_len) = ceil_div(returndata_size, 16)
    local exec_env_ : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size,
        calldata_len=exec_env.calldata_len,
        calldata=exec_env.calldata,
        returndata_size=exec_env.returndata_size,
        returndata_len=exec_env.returndata_len,
        returndata=exec_env.returndata,
        to_returndata_size=returndata_size,
        to_returndata_len=returndata_len,
        to_returndata=returndata)
    let exec_env : ExecutionEnvironment* = &exec_env_
    return ()
end
