%lang starknet

# This module is for functions that correspond to Yul builtin
# instructions. All such functions must take only Uint256's as
# explicit parameters and return tuples of Uint256's. Furthermore,
# they must be named just as their Yul counterparts. This way we
# ensure that they don't clash with some other names in the translated
# yul code.

from starkware.cairo.common.dict_access import DictAccess
from starkware.starknet.common.syscalls import get_contract_address

from evm.calls import returndata_write
from evm.exec_env import ExecutionEnvironment
from evm.uint256 import Uint256
from evm.utils import felt_to_uint256

func address{syscall_ptr : felt*, range_check_ptr}() -> (contract_address : Uint256):
    let (felt_address) = get_contract_address()
    let (uint_address) = felt_to_uint256(felt_address)
    return (uint_address)
end

func warp_return{
        memory_dict : DictAccess*, exec_env : ExecutionEnvironment*, range_check_ptr,
        termination_token}(returndata_ptr : Uint256, returndata_size : Uint256):
    alloc_locals
    let termination_token = 1
    returndata_write(returndata_ptr.low, returndata_size.low)
    return ()
end
