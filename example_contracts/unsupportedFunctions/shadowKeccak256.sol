// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test() public pure returns (uint256) {
        return uint256(keccak256("ccc"));
    }

    function keccak256(bytes memory) public pure returns (bytes32) {
      return 0x00;
    }
}
