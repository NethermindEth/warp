pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function implicit(uint8 x, uint256 y) pure public returns (uint8, uint256) {
    return (x,y);
  }

  function explicit(uint8 x, uint256 y) pure public returns (uint8, uint256) {
    return (uint8(x), uint256(y));
  }
}
