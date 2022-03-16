pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[5] x;

  function get(uint256 offset) view public returns (uint8) {
    return x[offset];
  }

  function set(uint256 offset, uint8 value) public returns (uint8) {
    return x[offset] = value;
  }

  function length() view public returns (uint256) {
    return x.length;
  }
}
