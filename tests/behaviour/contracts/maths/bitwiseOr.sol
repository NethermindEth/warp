pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function bitwise_or8safe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs | rhs;
  }

  function bitwise_or8unsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs | rhs;
    }
  }

  function bitwise_or256safe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs | rhs;
  }

  function bitwise_or256unsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs | rhs;
    }
  }

  function bitwise_or8signedsafe (int8 lhs, int8 rhs) pure public returns (int8) {
    return lhs | rhs;
  }

  function bitwise_or8signedunsafe (int8 lhs, int8 rhs) pure public returns (int8) {
    unchecked {
      return lhs | rhs;
    }
  }

  function bitwise_or256signedsafe (int256 lhs, int256 rhs) pure public returns (int256) {
    return lhs | rhs;
  }

  function bitwise_or256signedunsafe (int256 lhs, int256 rhs) pure public returns (int256) {
    unchecked {
      return lhs | rhs;
    }
  }
}
