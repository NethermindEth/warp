pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
    function simpleScalar(bool choice, uint8 a, uint8 b) pure public returns (uint8) {
        return choice ? a : b;
    }
}
