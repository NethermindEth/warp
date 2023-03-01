pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

contract WARP {
    uint8[] simple;
    uint8[][] nested;

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

    function copySimpleArrayToIdentifier() external returns (uint8[] memory) {
        uint8[] memory x;
        x = simple;
        return x;
    }

    function testNestedArray(uint8[] memory a, uint8[] memory b, uint8[] memory c) public returns (uint8[] memory, uint8[] memory, uint8[] memory) {
        uint8[][] memory m = new uint8[][](3);
        m[0] = a;
        m[1] = b;
        m[2] = c;
        nested = m;

        return (nested[0], nested[1], nested[2]);
    }
}
