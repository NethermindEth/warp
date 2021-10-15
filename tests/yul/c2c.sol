pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function callMe(address add, uint8[] calldata arr) external view returns (bool) {
                  // Here's my number
    return WARP(add).callMeMaybe(arr);
  }

  function callMeMaybe(uint8[] calldata arr) external pure returns (bool) {
    if (arr.length > 8) {
      return false;
    } 
    return true;
  }
}
