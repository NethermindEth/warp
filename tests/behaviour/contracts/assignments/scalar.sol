pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function test(uint8 a) pure public returns (uint8) {
    uint8 x = 4;
    x = a;
    return x;
  }

  function test256(uint256 a) pure public returns (uint256) {
    uint256 x = 4;
    x = a;
    return x;
  }
}