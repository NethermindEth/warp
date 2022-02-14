pragma solidity ^0.8.10;

//SPDX-License-Identifer

contract WARP {
  function left() pure public returns (uint8) {
    uint8 x;
    uint256 y;
    return x << y;
  }

  function right() pure public returns (uint8) {
    uint8 x;
    uint256 y;
    return x >> y;
  }
}