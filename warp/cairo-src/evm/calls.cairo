from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from evm.array import array_copy_to_memory
from evm.array import array_load
from evm.exec_env import ExecutionEnvironment
from evm.utils import update_msize

func get_caller_data_uint256{syscall_ptr : felt*, range_check_ptr}() -> (caller_data : Uint256):
    alloc_locals
    let (local caller_address) = get_caller_address()
    let (local high, local low) = split_felt(caller_address)
    let caller_data = Uint256(low=low, high=high)

    return (caller_data=caller_data)
end

func calldatacopy_{
        memory_dict : DictAccess*, range_check_ptr, msize, exec_env : ExecutionEnvironment}(
        dest_offset : Uint256, offset : Uint256, length : Uint256) -> ():
    alloc_locals
    let (local msize) = update_msize(msize, dest_offset.low, length.low)
    local memory_dict : DictAccess* = memory_dict
    array_copy_to_memory(
        exec_env.calldata_len, exec_env.calldata, dest_offset.low, offset.low, length.low)
    return ()
end

func calldata_load{range_check_ptr, exec_env : ExecutionEnvironment}(offset) -> (value : Uint256):
    alloc_locals
    let (local value : Uint256) = array_load(exec_env.calldata_len, exec_env.calldata, offset)
    return (value=value)
end
