pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    function test(bool x, bool y) public pure returns (bool) {
        return x || y;
    }
}
