pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

interface IWarp {
  function callMeMaybe(uint8 arr) external pure returns (bool);
}

contract WARP {
  function callMe(address add) external pure returns (bool) {
                  // Here's my number
    return IWarp(add).callMeMaybe(66);
  }

}
