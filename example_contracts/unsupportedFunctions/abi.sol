// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test(bytes memory _input) public pure returns (uint256) {
        uint256 a = abi.decode(_input, (uint256));
        return a;
    }
}
