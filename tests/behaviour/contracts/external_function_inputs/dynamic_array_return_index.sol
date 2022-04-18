pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
    function call (uint8 x, uint8[] memory z) pure internal {
        uint8 z = x;
    }
    function test(uint8[] memory x, uint8 y) pure external returns (uint8) {
    call(y, x);
        return (x[2]);
    }
}