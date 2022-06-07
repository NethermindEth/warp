pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  int16[2][3] x;

  function test(int8[2][2] calldata y) external returns (int16, int16, int16, int16) {
    x = y;
    return (x[1][1], x[1][0], x[0][1], x[0][0]);
  }
}
