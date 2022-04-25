// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
  uint256 public a;

  constructor(uint256 _a) price(_a) {
    a = _a;
  }

  modifier price(uint256 value) virtual {
    if (value >= 100) {
      _;
    }
  }
}

contract B is A {
  constructor(uint256 val) A(val) {}

  modifier price(uint256 value) override {
    if (value >= 1000) {
      _;
    }
  }
}
