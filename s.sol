// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

contract WARP {
    uint[] x;

    function test(uint[5] calldata y) external {
        x = y;
    }
}