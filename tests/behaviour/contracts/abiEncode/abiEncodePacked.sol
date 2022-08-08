// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    // Value Types
    function fixedBytes(bytes18 b1, bytes32 b2) public pure returns (bytes memory) {
        return abi.encodePacked(b1, b2);
    }

    function addresses(address a1, address a2) public pure returns (bytes memory) {
        return abi.encodePacked(a1, a2);
    }

    function booleans(bool b1, bool b2) public pure returns (bytes memory) {
        return abi.encodePacked(b1, b2);
    }

    enum Choices {Left, Right, Up, Down}
    function enums(Choices c1, Choices c2) public pure returns (bytes memory) {
        return abi.encodePacked(c1, c2);
    }

    // Reference Types
    function bArray (bytes memory a, bytes memory b) public pure returns (bytes memory) {
        return abi.encodePacked(a, b);
    }

    function dynArray (uint32[] memory a, uint256[] memory b) public pure returns (bytes memory) {
        return abi.encodePacked(a, b);
    }

    function staticArray(uint8[2] memory u8, uint32[3] memory u32) public pure returns (bytes memory) {
        return abi.encodePacked(u8, u32);
    }
}
