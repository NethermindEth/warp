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

  function preIncrement(uint256 a) pure public returns (uint256, uint256) {
    uint256 x = ++a;
    return (a,x);
  }

  function postIncrement(uint256 a) pure public returns (uint256, uint256) {
    uint256 x = a++;
    return (a,x);
  }

  function preDecrement(uint256 a) pure public returns (uint256, uint256) {
    uint256 x = --a;
    return (a,x);
  }

  function postDecrement(uint256 a) pure public returns (uint256, uint256) {
    uint256 x = a--;
    return (a,x);
  }
}
