from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.hash_chain import hash_chain
from starkware.cairo.common.keccak import unsafe_keccak
from starkware.cairo.common.math import unsigned_div_rem

from evm.array import array_copy_from_memory, array_create_from_memory
from evm.pow2 import pow2
from evm.uint256 import Uint256
from evm.utils import ceil_div, felt_to_uint256, update_msize

func sha{range_check_ptr, memory_dict : DictAccess*, msize, bitwise_ptr : BitwiseBuiltin*}(
        offset, size) -> (res : Uint256):
    alloc_locals
    let (msize) = update_msize(msize, offset, size)
    let (size_div, size_rem) = unsigned_div_rem(size, 16)
    if size_rem == 0:
        let (memval) = array_create_from_memory(offset, size)
        let (low, high) = unsafe_keccak(memval, size)
        return (res=Uint256(low, high))
    end
    let (memval_init) = array_create_from_memory(offset, size_div * 16)
    let (memval_last) = array_create_from_memory(offset + size_div * 16, size_rem)
    let (d) = pow2(128 - 8 * size_rem)
    assert memval_init[size_div] = memval_last[0] / d
    let (low, high) = unsafe_keccak(memval_init, size)
    return (res=Uint256(low, high))
end

func uint256_sha{range_check_ptr, memory_dict : DictAccess*, msize, bitwise_ptr : BitwiseBuiltin*}(
        offset : Uint256, size : Uint256) -> (res : Uint256):
    return sha(offset.low, size.low)
end

func pedersen{
        range_check_ptr, pedersen_ptr : HashBuiltin*, memory_dict : DictAccess*, msize,
        bitwise_ptr : BitwiseBuiltin*}(offset, size) -> (res):
    alloc_locals
    let (msize) = update_msize(msize, offset, size)
    let (array) = alloc()
    let (array_len) = ceil_div(size, 16)
    array[0] = array_len
    array_copy_from_memory(offset, size, array + 1)
    let (res) = hash_chain{hash_ptr=pedersen_ptr}(array)
    return (res)
end

func uint256_pedersen{
        range_check_ptr, pedersen_ptr : HashBuiltin*, memory_dict : DictAccess*, msize,
        bitwise_ptr : BitwiseBuiltin*}(offset : Uint256, size : Uint256) -> (res : Uint256):
    let (felt_res) = pedersen(offset.low, size.low)
    let (res) = felt_to_uint256(felt_res)
    return (res)
end
