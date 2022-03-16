pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  struct S{
    mapping(uint8 => uint8) map;
  }
  S[] x;

  function nesting() public returns (uint8) {
    x.push();
    x[0].map[4] = 5;
    mapping(uint8 => uint8) storage map = x[0].map;
    x.pop();
    return map[4];
  }
}
