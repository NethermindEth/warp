pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  function addition() pure public returns (uint256) {
    uint256 a = 15;
    uint256 b = 27;
    return a + b;
  }

  function multiplication() pure public returns (uint256) {
    uint256 a = 123;
    uint256 b = 234;
    return a * b;
  }
}