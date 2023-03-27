pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract Warp {
  int16 x = type(int16).max;
  int16 constant y = type(int16).min + type(int8).max;

  function bounds() pure public {
    uint8 a = type(uint8).max;
    uint8 b = type(uint8).min;
    uint256 big = type(uint256).max;
    int256 bigSigned = type(int256).max;
    uint256 bigMin = type(uint256).min;
    int256 bigMinSigned = type(int256).min;
    int256 c = -4;
  }
}
