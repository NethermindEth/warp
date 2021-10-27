pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function callMeMaybe(uint8 arr) external pure returns (uint) {
    if (arr > 8) {
      return 500000;
    } 
    return 52;
  }
}
