pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function explicit(int16 x, int256 y) pure public returns (int8, int136) {
    return (int8(x), int136(y));
  }
}
