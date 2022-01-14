pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

  function multiReturn() pure public returns (uint8, int16) {
    return (1,2);
  }

  function func() pure public {
    (int16 x, int y) = multiReturn();
  }
}
