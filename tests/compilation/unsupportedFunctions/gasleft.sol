// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test() public view returns (uint256) {
        uint256 a = gasleft();
        return a;
    }
}