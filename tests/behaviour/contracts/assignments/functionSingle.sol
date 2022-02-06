pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {

  function id(uint8 input) pure public returns (uint8) {
    return input;
  }

  function test(uint8 a) pure public returns (uint8) {
    uint8 x = 4;
    x = id(a);
    return x;
  }

  function id256(uint256 input) pure public returns (uint256) {
    return input;
  }

  function test256(uint256 a) pure public returns (uint256) {
    uint256 x = 4;
    x = id256(a);
    return x;
  }
}