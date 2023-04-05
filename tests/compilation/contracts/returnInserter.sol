pragma solidity ^0.8.6;
// SPDX-License-Identifier: GPL-3.0

contract WARP {

    function ifFunctionaliser_returnInserter(uint8 x) public pure returns (uint8 i, uint j) {
        if (x == 1) {
            i = 1;
        } else {
            i = 2;
        }
    }
}
