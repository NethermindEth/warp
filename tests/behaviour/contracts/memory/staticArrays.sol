pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
    function uint8default() pure public returns (uint8, uint8) {
        uint8[2] memory x;
        return (x[0], x[1]);
    }

    function uint8write(uint8 v) pure public returns (uint8, uint8) {
        uint8[2] memory x;
        x[1] = v;
        return (x[0], x[1]);
    }

    function uint256default() pure public returns (uint256, uint256) {
        uint256[2] memory x;
        return (x[0], x[1]);
    }

    function uint256write(uint256 v) pure public returns (uint256, uint256) {
        uint256[2] memory x;
        x[1] = v;
        return (x[0], x[1]);
    }

    function assignToTuple(uint8 a, uint8 b) pure public returns (uint8, uint8) {
        uint8[2] memory arr = [a, b];
        return (arr[0], arr[1]);
    }
}
