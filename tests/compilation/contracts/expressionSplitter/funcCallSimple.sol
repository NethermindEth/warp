// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.6;

contract C {
  function f() public pure returns (uint) {
    uint a = g() + 5;
    return a;
  }
  function g() public pure returns (uint) {
    return 10;
  }
}
