// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test() public pure returns (uint256) {
        return uint256(keccak256("c"));
    }

    function test(bytes memory f) public pure returns (uint256) {
      return uint256(keccak256(f));
    }

    function test2(bytes calldata f) public pure returns (uint256) {
      return uint256(keccak256(f));
    }
}
