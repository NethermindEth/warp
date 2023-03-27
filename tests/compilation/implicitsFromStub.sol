pragma solidity ^0.8.14;

contract C {

    ///warp-cairo
    ///func CURRENTFUNC(){ bitwise_ptr :BitwiseBuiltin* ,pedersen_ptr: HashBuiltin*,range_check_ptr}(lhs : felt, rhs : felt) -> (res : felt){
    ///from starkware.cairo.common.bitwise import bitwise_or
    ///    let (res) = bitwise_or(lhs, rhs);
    ///    return (res,);
    ///}
    function f(uint8 a, uint8 b) internal pure {
    }

    function g() external pure {
        f(10, 12);
    }
}
