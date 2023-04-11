pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  int8 x = 3;
  int256 y = 5;
  int256 z = 1;

  function f() public {
    x = x + 1;
    int256 a = y;
    y = z;
    z = a;
  }
}
