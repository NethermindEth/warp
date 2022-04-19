// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
  uint256 public a;

  constructor(uint256 _a) {
    a = _a;
  }
}

contract D {
  uint256 public d;

  constructor(uint256 _d) {
    d = _d;
  }
}

abstract contract B is A {
  uint256 public b;

  constructor(uint256 _b, uint256 d) A(d + 3) {
    b = _b + a;
  }
}

contract C is B(5, 6), D(4) {
  uint256 public c;

  constructor() {
    c = d + a;
  }
}
