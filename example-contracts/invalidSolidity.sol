pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function noSemicolon() pure public {
    uint256 a = 3
  }
}
