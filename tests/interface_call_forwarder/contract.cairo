%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.add import warp_add256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.sub import warp_sub256

@view
func add{syscall_ptr: felt*, range_check_ptr: felt}(a: Uint256, b: Uint256) -> (res: Uint256) {
    alloc_locals;

    warp_external_input_check_int256(b);

    warp_external_input_check_int256(a);

    let (__warp_se_0) = warp_add256(a, b);

    return (__warp_se_0,);
}

@view
func sub{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    a: Uint256, b: Uint256
) -> (res: Uint256) {
    alloc_locals;

    warp_external_input_check_int256(b);

    warp_external_input_check_int256(a);

    let (__warp_se_1) = warp_sub256(a, b);

    return (__warp_se_1,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","add(uint256,uint256)","sub(uint256,uint256)"]