pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  function and(bool lhs, bool rhs) pure public returns (bool) {
    return lhs && rhs;
  }

  function or(bool lhs, bool rhs) pure public returns (bool) {
    return lhs || rhs;
  }
}
