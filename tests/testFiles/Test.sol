// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract WarpNoInputs {
  uint256 public value;

  constructor() {
    value = 1234;
  }

  function testNoInputs() external pure returns (uint) {
    return 10;
  }
}

contract WarpInputs{
  int8 public value;

  constructor(int8 x) {
    value = x;
  }

  function testInputs(int x) external pure returns (int) {
    return x;
  }
}
