pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

struct S { uint256 v; string s; }

contract WARP
{
  S public s;

  function set(uint u, string memory str) public {
    s.v = u;
    s.s = str;
  }
}
