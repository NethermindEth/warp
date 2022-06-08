// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
    function testMemoryBytes(bytes memory f) public pure returns (uint256) {
      return uint256(keccak256(f));
    }

    function testCalldataBytes(bytes calldata f) public pure returns (uint256) {
      return uint256(keccak256(f));
    }

    function testString() public pure returns (uint256) {
      return uint256(keccak256("c"));
    }
}
