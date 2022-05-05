pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  struct S {
    uint a;
  }
  function test(uint8 x) pure public returns (uint8) {
    1;
    1+1;
    x;
    x + 1;
    S(x);
    return x;
  }
}
