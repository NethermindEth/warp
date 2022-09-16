from starkware.starknet.common.syscalls import get_block_number, get_block_timestamp
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.utils import felt_to_uint256

func warp_block_number{syscall_ptr: felt*, range_check_ptr: felt}() -> (block_num: Uint256) {
    alloc_locals;
    let (felt_block_num) = get_block_number();
    let (uint256_block_num) = felt_to_uint256(felt_block_num);
    return (uint256_block_num,);
}

func warp_block_timestamp{syscall_ptr: felt*, range_check_ptr: felt}() -> (
    block_timestamp: Uint256
) {
    alloc_locals;
    let (felt_block_timestamp) = get_block_timestamp();
    let (uint256_block_timestamp) = felt_to_uint256(felt_block_timestamp);
    return (uint256_block_timestamp,);
}
