// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
  uint256 public called;
  modifier mod1() {
    called++;
    _;
  }

  function fact(uint256 x) public mod1 returns (uint256 r) {
    if (x == 0) return 1;
    return x * fact(x - 1);
  }
}
