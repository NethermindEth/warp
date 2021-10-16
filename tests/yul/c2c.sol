pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  uint8[] arr = [1,2,3];

  function callMe(address add) external view returns (bool) {
                  // Here's my number
    return WARP(add).callMeMaybe(arr);
  }

  function callMeMaybe(uint8[] memory arg) external pure returns (bool) {
    if (arg.length > 8) {
      return false;
    } 
    return true;
  }
}