%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.add import warp_add256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from warplib.maths.sub import warp_sub256


namespace A {
    // Dynamic variables - Arrays and Maps

    // Static variables
}

@view
func add_771602f7{syscall_ptr: felt*, range_check_ptr: felt}(
    __warp_usrid0_a: Uint256, __warp_usrid1_b: Uint256
) -> (__warp_usrid2_: Uint256) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid1_b);

    warp_external_input_check_int256(__warp_usrid0_a);

    let (__warp_se_0) = warp_add256(__warp_usrid0_a, __warp_usrid1_b);

    return (__warp_se_0,);
}

@view
func sub_b67d77c5{syscall_ptr: felt*, range_check_ptr: felt, bitwise_ptr: BitwiseBuiltin*}(
    __warp_usrid3_a: Uint256, __warp_usrid4_b: Uint256
) -> (__warp_usrid5_: Uint256) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid4_b);

    warp_external_input_check_int256(__warp_usrid3_a);

    let (__warp_se_1) = warp_sub256(__warp_usrid3_a, __warp_usrid4_b);

    return (__warp_se_1,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;

    return ();
}

// Original soldity abi: ["constructor()","add(uint256,uint256)","sub(uint256,uint256)"]
