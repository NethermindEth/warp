pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function lt8safe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs < rhs;
  }

  function lt8unsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    unchecked {
      return lhs < rhs;
    }
  }

  function lt256safe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    return lhs < rhs;
  }

  function lt256unsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    unchecked {
      return lhs < rhs;
    }
  }

  function lt8signedsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    return lhs < rhs;
  }

  function lt8signedunsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    unchecked {
      return lhs < rhs;
    }
  }

  function lt256signedsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    return lhs < rhs;
  }

  function lt256signedunsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    unchecked {
      return lhs < rhs;
    }
  }
}
