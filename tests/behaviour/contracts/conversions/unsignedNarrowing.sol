pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function explicit(uint16 x, uint256 y) pure public returns (uint8, uint136) {
    return (uint8(x), uint136(y));
  }
}
