// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    function t0(bytes18 b1, bytes32 b2) public pure returns (bytes memory) {
        return abi.encodePacked(b1, b2);
    }
}
