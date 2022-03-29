pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8 a = 3;
  
  function value_passing(uint8 a) pure public returns (uint8) {
    uint8 b = a;
    uint8 a = 15;
    return a;
  }

}
