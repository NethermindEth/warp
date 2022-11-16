pragma solidity ^0.8.14;

// SPDX-License-Identifier: MIT

contract WARP {
    uint256 constant x = 10_000;
    int constant y = 10_000;

    function a() public pure returns (uint256) {
        if(5_000 > 3_000)
            return x;
        return 0;
    }

    function b() public pure returns (int) {
        return y;
    }
}
