pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function division8safe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs / rhs;
  }

  function division8unsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs / rhs;
    }
  }

  function division256safe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs / rhs;
  }

  function division256unsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs / rhs;
    }
  }

  function division8signedsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs / rhs;
  }

  function division8signedunsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs / rhs;
    }
  }

  function division256signedsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs / rhs;
  }

  function division256signedunsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs / rhs;
    }
  }
}
