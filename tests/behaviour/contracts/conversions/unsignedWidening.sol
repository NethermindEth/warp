pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function implicit(uint8 x) pure public returns (uint16, uint256) {
    return (x,x);
  }

  function explicit(uint8 x) pure public returns (uint16, uint256) {
    return (uint16(x), uint256(x));
  }
}
