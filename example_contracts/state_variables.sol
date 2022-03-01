pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  struct bants {
    int256 a;
    mapping(address => address) b;
  }
  uint256 a = 4;
  mapping(address => mapping(uint256 => address)) public b;
  mapping(address => bants) public d;
}
