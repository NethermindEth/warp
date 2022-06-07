pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function remainder8safe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs % rhs;
  }

  function remainder8unsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs % rhs;
    }
  }

  function remainder256safe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs % rhs;
  }

  function remainder256unsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs % rhs;
    }
  }

  function remainder8signedsafe (int8 lhs, int8 rhs) pure public returns (int8) {
    return lhs % rhs;
  }

  function remainder8signedunsafe (int8 lhs, int8 rhs) pure public returns (int8) {
    unchecked {
      return lhs % rhs;
    }
  }

  function remainder256signedsafe (int256 lhs, int256 rhs) pure public returns (int256) {
    return lhs % rhs;
  }

  function remainder256signedunsafe (int256 lhs, int256 rhs) pure public returns (int256) {
    unchecked {
      return lhs % rhs;
    }
  }
}
