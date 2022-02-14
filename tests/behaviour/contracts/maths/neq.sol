pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function neq8safe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs != rhs;
  }

  function neq8unsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    unchecked {
      return lhs != rhs;
    }
  }

  function neq256safe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    return lhs != rhs;
  }

  function neq256unsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    unchecked {
      return lhs != rhs;
    }
  }

  function neq8signedsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs != rhs;
  }

  function neq8signedunsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    unchecked {
      return lhs != rhs;
    }
  }

  function neq256signedsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    return lhs != rhs;
  }

  function neq256signedunsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    unchecked {
      return lhs != rhs;
    }
  }
}
