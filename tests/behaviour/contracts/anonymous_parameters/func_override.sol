pragma solidity ^0.8.14;

//SPDX-License-Identifier: MIT

contract A {

    function f8(uint8, uint8) virtual external pure returns (uint8) {
        return 10;
    }

    function f256(uint256, uint256) virtual external pure returns (uint256) {
        return 10;
    }
}

contract B is A {

    function f8(uint8 x0, uint8 x1 ) override external pure returns (uint8) {
        return x0 + x1;
    }

    function f256(uint256 x0, uint256 x1 ) override external pure returns (uint256) {
        return x0 + x1;
    }

    function one_argument8(uint8 x0, uint8) external pure returns (uint8) {
        return x0 + 7;
    }

    function one_argument256(uint256 x0, uint256) external pure returns (uint256) {
        return x0 + 7;
    }
}
