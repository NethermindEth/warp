// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test() public pure returns (address) {
        address b = ecrecover(0x00, 0, 0x00, 0x00);
        return b;
    }
}
