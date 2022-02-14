pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  function multiplication8safe(uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs * rhs;
  }

  function multiplication128safe(uint128 lhs, uint128 rhs) pure public returns (uint128) {
    return lhs * rhs;
  }

  function multiplication256safe(uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs * rhs;
  }

  function multiplication8unsafe(uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs * rhs;
    }
  }

  function multiplication128unsafe(uint128 lhs, uint128 rhs) pure public returns (uint128) {
    unchecked {
      return lhs * rhs;
    }
  }

  function multiplication256unsafe(uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs * rhs;
    }
  }

  function multiplication8signedsafe(int8 lhs, int8 rhs) pure public returns (int8) {
    return lhs * rhs;
  }

  function multiplication128signedsafe(int128 lhs, int128 rhs) pure public returns (int128) {
    return lhs * rhs;
  }

  function multiplication256signedsafe(int256 lhs, int256 rhs) pure public returns (int256) {
    return lhs * rhs;
  }

  function multiplication8signedunsafe(int8 lhs, int8 rhs) pure public returns (int8) {
    unchecked {
      return lhs * rhs;
    }
  }

  function multiplication128signedunsafe(int128 lhs, int128 rhs) pure public returns (int128) {
    unchecked {
      return lhs * rhs;
    }
  }

  function multiplication256signedunsafe(int256 lhs, int256 rhs) pure public returns (int256) {
    unchecked {
      return lhs * rhs;
    }
  }
}
