//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {

    function bytes2access(uint256 index) pure public returns (bytes1) {
        bytes2 a = 0x1122;
        return a[index];
    }

    function bytes12access(uint256 index) pure public returns (bytes1) {
        bytes12 a = 0x112211221122112211221122;
        return a[index];
    }

    function bytes17access(uint256 index) pure public returns (bytes1) {
        bytes17 a = 0x123456789abcdef0123456789abcdef012;
        return a[index];
    }

    function bytes24access(uint256 index) pure public returns (bytes1) {
        bytes24 a = 0x222222222222222222222222222222222222222222222222;
        return a[index];
    }

    function bytes31access(uint256 index) pure public returns (bytes1) {
        bytes31 a = 0xfe45edeacbfe456ff3eadbbccde3535d89011123dc4c4cd5faec11224433ff;
        return a[index];
    }

    function bytes32access(uint112 index) pure public returns (bytes1) {
        bytes32 a = 0x3333333333333333333333333333333344444444444444444444444444444444;
        return a[index];
    }

    function bytes32access256(uint256 index) pure public returns (bytes1) {
        bytes32 a = 0xff11111111111111111111111111111111111111111111111111111111111111;
        return a[index];
    }
}
