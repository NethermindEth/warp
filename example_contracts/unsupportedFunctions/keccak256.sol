// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test() public pure returns (uint256) {
        return uint256(keccak256("cccc"));
    }
}
