pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
    uint x;

    function voidReturn() public {
        return (x == 0) ? g() : (x < 10) ? f() : delete x;
    }
    function f() public {
        x = 10;
    }
    function g() public {
        x = 5;
    }
}
