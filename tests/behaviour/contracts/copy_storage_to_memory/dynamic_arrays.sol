pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

contract WARP {
    uint8[] simple;

    constructor() {
        simple.push(5);
        simple.push();
        simple.push(4);
    }

    function copySimpleArrayLength() public returns (uint256) {
        uint8[] memory m = simple;
        return (m.length);
    }

    function copySimpleArrayValues() public returns (uint8, uint8, uint8) {
        uint8[] memory m = simple;
        return (m[0], m[1], m[2]);
    }
}
