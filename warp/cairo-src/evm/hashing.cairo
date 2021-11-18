from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.hash_chain import hash_chain
from starkware.cairo.common.keccak import unsafe_keccak

from evm.array import array_copy_from_memory, array_create_from_memory
from evm.uint256 import Uint256
from evm.utils import ceil_div, felt_to_uint256, update_msize

func sha{range_check_ptr, memory_dict : DictAccess*, msize}(offset, length) -> (res : Uint256):
    alloc_locals
    let (msize) = update_msize(msize, offset, length)
    let (memval) = array_create_from_memory(offset, length)
    let (low, high) = unsafe_keccak(memval, length)
    return (res=Uint256(low, high))
end

func uint256_sha{range_check_ptr, memory_dict : DictAccess*, msize}(
        offset : Uint256, length : Uint256) -> (res : Uint256):
    return sha(offset.low, length.low)
end

func pedersen{range_check_ptr, pedersen_ptr : HashBuiltin*, memory_dict : DictAccess*, msize}(
        offset, length) -> (res):
    alloc_locals
    let (msize) = update_msize(msize, offset, length)
    let (array) = alloc()
    let (array_len) = ceil_div(length, 16)
    array[0] = array_len
    array_copy_from_memory(offset, length, array + 1)
    let (res) = hash_chain{hash_ptr=pedersen_ptr}(array)
    return (res)
end

func uint256_pedersen{
        range_check_ptr, pedersen_ptr : HashBuiltin*, memory_dict : DictAccess*, msize}(
        offset : Uint256, length : Uint256) -> (res : Uint256):
    let (felt_res) = pedersen(offset.low, length.low)
    let (res) = felt_to_uint256(felt_res)
    return (res)
end
