pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

contract WARP {
  uint[] x;
  uint[2] y;

  function setStatic(uint a, uint b) external returns (uint[2] memory) {
    y = [a,b];
    return y;
  }

  function copyStaticToDynamic() external returns (uint[] memory, uint[2] memory) {
    x = y;
    return (x,y);
  }
}