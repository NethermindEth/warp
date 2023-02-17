// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract A{
    function ret(uint8 a, uint8 b) public pure returns (uint8, uint8){
        return (a+b, a-b);
    }
}
