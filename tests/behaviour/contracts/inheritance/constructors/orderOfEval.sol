pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract A {
  uint256[] x;

  constructor(uint256) {}

  function f(uint256 _x) internal returns (uint256) {
    x.push(_x);
  }
}

contract B {
  constructor(uint256) {}
}

abstract contract C is A {
  constructor(uint256) {}
}

abstract contract D is C {
  constructor(uint256) C(f(2)) {}
}

contract X is B, D {
  function g() public view returns (uint256[] memory) {
    return x;
  }

  constructor() A(f(1)) B(f(3)) D(f(4)) {}
}
