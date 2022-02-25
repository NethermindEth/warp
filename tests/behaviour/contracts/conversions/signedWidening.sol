pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function implicit(int8 x) pure public returns (int16, int256) {
    return (x,x);
  }

  function explicit(int8 x) pure public returns (int16, int256) {
    return (int16(x), int256(x));
  }
}
