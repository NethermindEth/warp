pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

contract WARP {

  int public a;

  function multiReturn() pure public returns (uint8, int16) {
    return (1,2);
  }

  function func() public {
    // This is disallowed in 0.8.0 but allowed in 0.7.0
    (int16 x, int y) = multiReturn();
    (int b, int c) = multiReturn();
    (b,c) = (c,b);
    a = b;
  }
}
