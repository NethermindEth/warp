pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
    function c0() public pure returns (bytes memory) {
        bytes memory m = bytes.concat();
        return m;
    }
    function c1(bytes memory x1) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1);
        return m;
    }
    function c2(bytes memory x1, bytes memory x2) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1, x2);
        return m;
    }
    function c3(bytes memory x1, bytes memory x2, bytes memory x3) public pure returns (bytes memory)     {
        bytes memory m = bytes.concat(x1, x2, x3);
        return m;
    }
}
