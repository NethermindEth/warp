// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.6;

contract WARP {
  function f() public pure returns (uint) {
    uint a = 8;
    uint b = (a = 5) + 5;
    return b;
  }
  function g() public pure returns (uint) {
    uint a = 8;
    uint b = (a = 5) + 5;
    return a + b;
  }
}
