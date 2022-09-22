// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract WARP {
    function f(bytes calldata x) public pure returns (bytes calldata) {
        return x;
    }

    function g(bytes calldata x) public view returns (bytes memory) {
        // bytes memory a = this.f(x);
        // return a;
        return this.f(x);
    }
}
