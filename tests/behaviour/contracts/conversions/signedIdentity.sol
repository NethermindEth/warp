pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function implicit(int8 x, int256 y) pure public returns (int8, int256) {
    return (x,y);
  }

  function explicit(int8 x, int256 y) pure public returns (int8, int256) {
    return (int8(x), int256(y));
  }
}
