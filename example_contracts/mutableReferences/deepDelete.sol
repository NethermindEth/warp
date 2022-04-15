pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  uint8[3][] arr;
  function test() public returns (uint8) {
    uint8[3] storage subArr = arr.push();
    subArr[1] = 5;
    delete arr;
    return subArr[1];
  }
}