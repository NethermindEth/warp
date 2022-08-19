// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP {
    function rational() public pure returns (bytes memory) {
        int8 a = -1;
        int16 b = -2;
        return abi.encode(a, b);
    }

    function rationalLiterals() public pure returns (bytes memory) {
        return abi.encode(1, -2);
    }
}

