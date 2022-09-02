pragma solidity ^0.8.14;

//SPDX-License-Identifier: MIT

contract A {

    function f(uint8, uint8) virtual external pure returns (uint8) {
        return 10;
    }
}

contract WARP is A {

    function f(uint8 x0, uint8 x1 ) override external pure returns (uint8) {
        return x0 + x1;
    }

    function one_argument(uint8 x0, uint8) external pure returns (uint8) {
        return x0 + 7;
    }
}