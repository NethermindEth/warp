pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
  State Variables with Elementary Types only
*/

contract WARP {

  uint256 public a;
  uint128 public b = 23;
  address public c;

  int d;
  int public e = 12;

  bool public f;

  address public g = address(b + uint256(0x1234));
}
