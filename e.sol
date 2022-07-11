pragma solidity 0.8.14;

// SPDX-License-Identifier: MIT

contract WARP {
    uint8[4] x;

    function f() external {
       uint8[] memory y;
       x[0] = 1;
    }
}