// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract C {
  function f() pure public returns (uint, uint) {
    return (1, 4);
  }
  function g() external pure returns (uint) {
    uint a;
    uint b;
    (a, b) = f();
    return a + b;
  }
}
