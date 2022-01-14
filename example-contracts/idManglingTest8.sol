pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  int x = 3;
  uint8 y = 3;

  function fn(int8 a, int8 b) public returns (int8) {
    int8 c = 5; {
      int8 c = 6;
      c = 7;
      x = c - b;
    }
    return a + c;
  }
}
