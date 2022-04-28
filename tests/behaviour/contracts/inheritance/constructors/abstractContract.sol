// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
  uint256 public a;

  constructor(uint256 _a) {
    a = _a;
  }
}

abstract contract B is A {
  function f(uint256 value) public view returns (uint256) {
    return value + a;
  }
}

contract C is B {
  constructor(uint256 val) A(val) {}
}
