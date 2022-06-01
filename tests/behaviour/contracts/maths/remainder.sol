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

  function remainder8signedsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs % rhs;
  }

  function remainder8signedunsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs % rhs;
    }
  }

  function remainder256signedsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs % rhs;
  }

  function remainder256signedunsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs % rhs;
    }
  }
}
