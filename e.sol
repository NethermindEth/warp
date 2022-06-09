pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {

  int16[][] z1;   // tick
  int16[2][] z2;  // now
  int16[2][2] z3; // tick
  int16[][2] z4;  // tick

  function test(int8[2][2] calldata yy) external {
    z2 = yy;
    }

}