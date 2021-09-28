from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import split_felt
from starkware.starknet.common.syscalls import get_caller_address
from evm.exec_env import ExecutionEnvironment
from evm.array import array_load

func get_caller_data_uint256{syscall_ptr : felt*, range_check_ptr}() -> (caller_data: Uint256):
  alloc_locals
  let (local caller_address) = get_caller_address()
  let (local high, local low) = split_felt(caller_address)
  let caller_data = Uint256(low=low, high=high)

  return (caller_data=caller_data)
end

func calldata_load{range_check_ptr, exec_env : ExecutionEnvironment}(offset) -> (value : Uint256):
    alloc_locals
    let (local value : Uint256) = array_load(exec_env.calldata_len, exec_env.calldata, offset)
    return (value=value)
end
