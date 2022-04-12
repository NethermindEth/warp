pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {


    function testReturnIndex(int16[3] memory listA) pure external returns (int16) {
        //int16[2] memory listB = [listA[1], listA[2]];
        return listA[2];
    }

}