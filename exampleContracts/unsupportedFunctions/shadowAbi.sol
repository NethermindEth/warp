// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AbiFunc {
    function decode(uint256, bytes memory) public pure returns (uint256) {
        return 0;
    }
}

contract Warp {
    using AbiFunc for uint256;
    uint256 abi;
    function test(bytes memory _input) public  returns (uint256) {
        uint256 a = abi.decode(_input);
        return a;
    }
}
