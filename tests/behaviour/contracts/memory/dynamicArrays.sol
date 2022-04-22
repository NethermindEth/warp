pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
    function uint8new() pure public returns (uint8, uint8) {
        uint8[] memory x = new uint8[](5);
        x[0] = 5;
        x[1] = 1;
        return (0, 1);
    }

    function uint8write(uint8 v) pure public returns (uint8, uint8) {
        uint8[] memory x = new uint8[](2);
        x[1] = v;
        return (x[0], x[1]);
    }

    function uint256new() pure public returns (uint256, uint256) {
        uint256[] memory x = new uint256[](2);
        return (x[0], x[1]);
    }

    function uint256write(uint256 v) pure public returns (uint256, uint256) {
        uint256[] memory x = new uint256[](2);
        x[1] = v;
        return (x[0], x[1]);
    }
}
