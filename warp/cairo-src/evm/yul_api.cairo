# This module is for functions that correspond to Yul builtin
# instructions. All such functions must take only Uint256's as
# explicit parameters and return tuples of Uint256's. Furthermore,
# they must be named just as their Yul counterparts. This way we
# ensure that they don't clash with some other names in the translated
# yul code.

from starkware.starknet.common.syscalls import get_contract_address

from evm.uint256 import Uint256
from evm.utils import felt_to_uint256

func address{syscall_ptr : felt*, range_check_ptr}() -> (contract_address : Uint256):
    let (felt_address) = get_contract_address()
    let (uint_address) = felt_to_uint256(felt_address)
    return (uint_address)
end
