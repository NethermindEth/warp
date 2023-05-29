pragma solidity ^0.8.6;
// SPDX-License-Identifier: MIT

contract WARP {
    function fromBytes(bytes32 b) pure public returns (address) {
        return address(b);
    }

    function fromUint256(uint256 u) pure public returns (address) {
        return address(u);
    }

    function fromAddress(address a) pure public returns (address) {
        return address(a);
    }

    function fromLiteral() pure public returns (address) {
        return address(5);
    }
}
