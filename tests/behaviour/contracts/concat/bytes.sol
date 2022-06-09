pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
    function c0() public pure returns (bytes memory) {
        bytes memory m = bytes.concat();
        return m;
    }
    function c1(bytes memory x1) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1);
        return m;
    }
    function c2(bytes memory x1, bytes memory x2) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1, x2);
        return m;
    }
    function c3(bytes memory x1, bytes memory x2, bytes memory x3) public pure returns (bytes memory)     {
        bytes memory m = bytes.concat(x1, x2, x3);
        return m;
    }
    function c4(bytes calldata x1, bytes calldata x2) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1, x2);
        return m;
    }
    function dynamicAndLiteral(bytes calldata b) public pure returns (bytes memory, bytes memory) {
        return (bytes.concat(b, "hi"),
        bytes.concat("hi", b));
    }

    function long() public pure returns (bytes memory) {
        return bytes.concat("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }

    bytes b1;
    bytes b2;
    function c5() public returns (bytes memory) {
        b1.push(0x01);
        b1.push(0x02);
        b2.push(0x03);
        b2.push(0x04);
        bytes memory m = bytes.concat(b1, b2);
        return m;
    }

    function d1(bytes3 x1) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1);      
        return m;
    }
    function d2(bytes1 x1, bytes32 x2) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1, x2);      
        return m;
    }
    function d3(bytes1 x1, bytes memory x2, bytes16 x3) public pure returns (bytes memory) {
        bytes memory m = bytes.concat(x1, x2, x3);      
        return m;
    }
    function staticAndLiteral(bytes2 b) public pure returns (bytes memory, bytes memory) {
        return (bytes.concat(b, "hi"),
        bytes.concat("hi", b));
    }
}

