// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP {
    struct Simple {
        uint8 m1;
        uint128[3] m2;
    }

    function decodeSimpleStruct(bytes memory data) public pure returns (Simple memory) {
        return abi.decode(data, (Simple));
    }

    function decodeSimpleStructArray(bytes memory data) public pure returns(Simple[] memory) {
        return abi.decode(data, (Simple[]));
    }

    struct Complex {
        uint8[] m1;
        Simple m2;
    }

    function decodeComplexStruct(bytes memory data) public pure returns (uint8[] memory, Simple memory) {
        Complex memory c = abi.decode(data, (Complex));
        return (c.m1, c.m2);
    }

    struct Complex2 {
        uint8[] m1;
        uint8[] m2;
    }

    function decodeComplex2Struct(bytes memory data) public pure returns (uint8[] memory, uint8[] memory) {
        Complex2 memory c = abi.decode(data, (Complex2));
        return (c.m1, c.m2);
    }
}
