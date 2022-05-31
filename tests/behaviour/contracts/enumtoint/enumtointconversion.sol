// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; 

contract WARP {
    enum Truth {False, True}

    function test() public returns (uint256) {
        return uint256(Truth(uint8(0x1)));
    }
}
