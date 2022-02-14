pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  function subtraction8safe(uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs - rhs;
  }

  function subtraction8unsafe(uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs - rhs;
    }
  }

  function subtraction200safe(uint200 lhs, uint200 rhs) pure public returns (uint200) {
    return lhs - rhs;
  }

  function subtraction200unsafe(uint200 lhs, uint200 rhs) pure public returns (uint200) {
    unchecked {
      return lhs - rhs;
    }
  }

  function subtraction256safe(uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs - rhs;
  }

  function subtraction256unsafe(uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs - rhs;
    }
  }

  function subtraction8signedsafe(int8 lhs, int8 rhs) pure public returns (int8) {
    return lhs - rhs;
  }

  function subtraction8signedunsafe(int8 lhs, int8 rhs) pure public returns (int8) {
    unchecked {
      return lhs - rhs;
    }
  }

  function subtraction200signedsafe(int200 lhs, int200 rhs) pure public returns (int200) {
    return lhs - rhs;
  }

  function subtraction200signedunsafe(int200 lhs, int200 rhs) pure public returns (int200) {
    unchecked {
      return lhs - rhs;
    }
  }

  function subtraction256signedsafe(int256 lhs, int256 rhs) pure public returns (int256) {
    return lhs - rhs;
  }

  function subtraction256signedunsafe(int256 lhs, int256 rhs) pure public returns (int256) {
    unchecked {
      return lhs - rhs;
    }
  }
}
