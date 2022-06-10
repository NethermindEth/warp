pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
    function test(bytes calldata x) public returns (bytes calldata) {
        return x;
    }
    function tester(bytes calldata x) public returns (bytes1) {
        return this.test(x)[2];
    }
}
