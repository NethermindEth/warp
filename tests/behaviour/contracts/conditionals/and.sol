// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
  uint256 public a;

  function f(uint256 value, bool flag) public returns (uint256) {
    uint256 y = 30;
    uint256 temp = g(y = 5, flag && check(y, value));
    return temp;
  }

  function check(uint256 y, uint256 val) private returns (bool) {
    a += 1;
    return y > val;
  }

  function g(uint256 ab, bool flag) private view returns (uint256) {
    if (flag) return ab;
    return a;
  }
}
