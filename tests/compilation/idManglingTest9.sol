// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

contract Warp {
    function f() public returns (uint8) {
        return g();
    }
    function s() internal returns (uint8) {
        return 10;
    }
}

function s() pure returns (uint8) {
    return 11;
}

function g() pure returns (uint8) {
    return 20;
}
