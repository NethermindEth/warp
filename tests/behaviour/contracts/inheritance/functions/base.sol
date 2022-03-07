pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract Base {
  function g(uint8 x) virtual pure public returns (uint8) {
    return x;
  }
}
