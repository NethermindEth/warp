from evm.array import array_create_from_memory
from evm.utils import update_msize
from evm.uint256 import Uint256
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.keccak import unsafe_keccak

func sha{range_check_ptr, memory_dict : DictAccess*, msize}(offset, length) -> (res : Uint256):
    alloc_locals
    let (local msize) = update_msize(msize, offset, length)
    let (local memval) = array_create_from_memory(offset, length)
    let (local low, local high) = unsafe_keccak(memval, length)
    return (res=Uint256(low, high))
end
