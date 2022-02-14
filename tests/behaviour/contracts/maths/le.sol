pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function le8safe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs <= rhs;
  }

  function le8unsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    unchecked {
      return lhs <= rhs;
    }
  }

  function le256safe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    return lhs <= rhs;
  }

  function le256unsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    unchecked {
      return lhs <= rhs;
    }
  }

  function le8signedsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    return lhs <= rhs;
  }

  function le8signedunsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    unchecked {
      return lhs <= rhs;
    }
  }

  function le256signedsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    return lhs <= rhs;
  }

  function le256signedunsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    unchecked {
      return lhs <= rhs;
    }
  }
}
