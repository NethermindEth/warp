// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract A {
  uint256 public x;

  constructor(uint256 val) {
    x = val;
  }

  fallback() external virtual limit {
    x += 1;
  }

  modifier limit() {
    require(x + 1 <= 100, 'x can not exceed the amount of 100');
    _;
  }

  function sub(uint256 y) public {
    x -= y;
  }
}

contract B is A {
  constructor(uint256 val) A(val) {}

  fallback() external override {
    x += 10;
  }
}

contract C is A {
  constructor(uint256 val) A(val) {}
}
