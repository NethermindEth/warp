pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    function f(uint a) public returns (uint) {
        uint a;
        uint b;
        (a,,b,) = ((1,2,3, g()));
    }

    function g() public returns (uint){

    }
}
