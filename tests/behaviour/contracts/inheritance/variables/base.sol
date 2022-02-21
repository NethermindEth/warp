pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract Base {
  uint x = 4;
  function g() virtual public returns (uint) {
    x *= 2;
    return x;
  }
}
