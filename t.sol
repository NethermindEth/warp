pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  int16[][] x;


    function test(int16[2][] calldata y) external  {
      x = y;
    }
}

