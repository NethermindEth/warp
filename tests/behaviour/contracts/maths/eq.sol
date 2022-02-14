pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function eq8safe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs == rhs;
  }

  function eq8unsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    unchecked {
      return lhs == rhs;
    }
  }

  function eq256safe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    return lhs == rhs;
  }

  function eq256unsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    unchecked {
      return lhs == rhs;
    }
  }

  function eq8signedsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    return lhs == rhs;
  }

  function eq8signedunsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    unchecked {
      return lhs == rhs;
    }
  }

  function eq256signedsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    return lhs == rhs;
  }

  function eq256signedunsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    unchecked {
      return lhs == rhs;
    }
  }
}
