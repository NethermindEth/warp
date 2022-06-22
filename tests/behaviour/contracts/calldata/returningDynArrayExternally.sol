pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
    function identity(bytes calldata x) public returns (bytes calldata) {
        return x;
    }

    function test(bytes calldata x) public returns (bytes memory) {
        return this.identity(x);
    }

    function testIndexing(bytes calldata x) public returns (bytes1) {
        return this.identity(x)[2];
    }

    function testTwice(bytes calldata x) public returns (bytes memory) {
        return this.test(this.test(x));
    }
}
