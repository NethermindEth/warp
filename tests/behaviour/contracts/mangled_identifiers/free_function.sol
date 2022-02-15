// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

contract Warp {
    // This contract cannot call the free function s
    function f() public returns (uint8) {
        return g();
    }
    function s() public returns (uint16) {
        return 10;
    }
}

function s() pure returns (uint8) {
    return 11;
}

function g() pure returns (uint8) {
    return 20;
}
