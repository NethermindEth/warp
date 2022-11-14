// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.6;

contract C {
  function f() public pure returns (uint) {
    uint a = 8;
    uint b = (a = 5) + 5;
    return b;
  }
}
