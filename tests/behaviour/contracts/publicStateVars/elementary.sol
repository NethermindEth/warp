pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
  State Variables with Elementary Types only
*/

contract WARP {

  uint256 public a;
  uint128 public b = 23;
  address public c;

  int public d;
  int public e = 12;

  bool public f;

  address public g = address(b + uint256(0x1234));
  constructor() public {
    a = 234;
    c = address(0x1234567890123456789012345678901234567890);
    d = -1;
    f = true;
  }
}
