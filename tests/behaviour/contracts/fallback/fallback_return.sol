// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract WARP {
  uint256 public x;

  fallback() external {
    if (x == 2) return;
    x++;
  }
}
