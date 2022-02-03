pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8 x = 2;
  int16 y = 4;

  function getValues() view public returns (uint8, int16) {
    return (x, y);
  }

  function readValues() view public returns (uint8, int16) {
    uint8 a = x;
    int16 b = y;
    return (a,b);
  }

  function setValues(uint8 a, int16 b) public {
    x = a;
    y = b;
  }
}