%lang starknet

// imports 
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin
from warplib.maths.utils import felt_to_uint256, narrow_safe

// existing structs


// transformed structs 


// tuple structs 


// forwarder interface 
@contract_interface
namespace Forwarder {

    func add(
        a: Uint256,
        b: Uint256,
    ) -> (res:Uint256){
    }
    func sub(
        a: Uint256,
        b: Uint256,
    ) -> (res:Uint256){
    }

}

//cast functions for structs 


//funtions to interact with given cairo contract
@view
func add_771602f7 {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    a: Uint256,
    b: Uint256,
) -> (
    res: Uint256,
) {
    alloc_locals;
    let a_cast = a;
    let b_cast = b;
    let (res_cast_rev) = Forwarder.add(0x04de3723f70bd1d1d62d48e8900fe81a5c411ec9eddd4d49b7f7e4fdff499007,a_cast,b_cast);
    let res = res_cast_rev;
    return (res,);
}
@view
func sub_b67d77c5 {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    a: Uint256,
    b: Uint256,
) -> (
    res: Uint256,
) {
    alloc_locals;
    let a_cast = a;
    let b_cast = b;
    let (res_cast_rev) = Forwarder.sub(0x04de3723f70bd1d1d62d48e8900fe81a5c411ec9eddd4d49b7f7e4fdff499007,a_cast,b_cast);
    let res = res_cast_rev;
    return (res,);
}