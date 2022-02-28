pragma solidity ^0.8.6;
// SPDX-License-Identifier: MIT

contract WARP {
  uint[] x;

  function ret(uint16 c) pure public returns (uint) {
    return c;
  }

  function test() external view {
    retRef(x);
  }

  function retRef(uint[] storage arr) pure internal returns(uint[] storage){
    return arr;
  }
}
