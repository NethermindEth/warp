pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  function addition8safe(uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs + rhs;
  }

  function addition8unsafe(uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs + rhs;
    }
  }

  function addition120safe(uint120 lhs, uint120 rhs) pure public returns (uint120) {
    return lhs + rhs;
  }

  function addition120unsafe(uint120 lhs, uint120 rhs) pure public returns (uint120) {
    unchecked {
      return lhs + rhs;
    }
  }

  function addition256safe(uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs + rhs;
  }

  function addition256unsafe(uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs + rhs;
    }
  }

  function addition8signedsafe(int8 lhs, int8 rhs) pure public returns (int8) {
    return lhs + rhs;
  }

  function addition8signedunsafe(int8 lhs, int8 rhs) pure public returns (int8) {
    unchecked {
      return lhs + rhs;
    }
  }

  function addition120signedsafe(int120 lhs, int120 rhs) pure public returns (int120) {
    return lhs + rhs;
  }

  function addition120signedunsafe(int120 lhs, int120 rhs) pure public returns (int120) {
    unchecked {
      return lhs + rhs;
    }
  }

  function addition256signedsafe(int256 lhs, int256 rhs) pure public returns (int256) {
    return lhs + rhs;
  }

  function addition256signedunsafe(int256 lhs, int256 rhs) pure public returns (int256) {
    unchecked {
      return lhs + rhs;
    }
  }
}
