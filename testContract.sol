pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function publicTestFunction (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs == rhs;
  }
}
