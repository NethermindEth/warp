pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract A {
  constructor(uint256) {}

  function f() internal pure returns (uint256) {
    return 1;
  }
}

abstract contract B is A{
  constructor(uint256) A(f()) {}
}
