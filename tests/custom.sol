// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract UncheckedMath {
    function add(uint x, uint y) external pure returns (uint) {
        unchecked {
            return x + y;
        }
    }
}