pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract Warp {
  int16 x = type(int16).max -10000;
  int16 constant y = type(int16).max + 1;

  function getY() public pure returns (int16) {
    return y;
  }

  function getZ() public view returns (int16) {
    return x - y;
  }

  function pureY() public pure returns (int16) {
    return y + 1;
  }
}
