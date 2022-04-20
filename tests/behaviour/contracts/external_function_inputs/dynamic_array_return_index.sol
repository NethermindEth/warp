pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
    // function testing (uint8 x, uint8[] memory z) pure internal returns (uint8[] memory) {
    //     return z;
    // }
    function test(uint8[] memory x) pure external returns (uint8) {
    // uint8[] memory testing_testing = testing(y, x);
        return (x[0]);
    }
}