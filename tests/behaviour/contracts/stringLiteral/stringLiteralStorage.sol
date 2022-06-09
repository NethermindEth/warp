pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

contract WARP {

    string str;

    function literalAssignment() public returns (string memory) {
        str = "WARP";
        return str;
    }

    function memoryToStorageAssignment() public returns (string memory) {
        string memory x = "WARP";
        str = x;
        return str;
    }
}