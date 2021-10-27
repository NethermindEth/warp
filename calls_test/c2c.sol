pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

interface IWarp {
  function callMeMaybe(uint8 arr) external pure returns (uint);
}

contract WARP {
  function callMe(address add) external returns (uint) {
                  // Here's my number
    return IWarp(add).callMeMaybe(66);
  }
}
