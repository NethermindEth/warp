pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function ge8safe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    return lhs >= rhs;
  }

  function ge8unsafe (uint8 lhs, uint8 rhs) pure public returns (bool) {
    unchecked {
      return lhs >= rhs;
    }
  }

  function ge256safe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    return lhs >= rhs;
  }

  function ge256unsafe (uint256 lhs, uint256 rhs) pure public returns (bool) {
    unchecked {
      return lhs >= rhs;
    }
  }

  function ge8signedsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    return lhs >= rhs;
  }

  function ge8signedunsafe (int8 lhs, int8 rhs) pure public returns (bool) {
    unchecked {
      return lhs >= rhs;
    }
  }

  function ge256signedsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    return lhs >= rhs;
  }

  function ge256signedunsafe (int256 lhs, int256 rhs) pure public returns (bool) {
    unchecked {
      return lhs >= rhs;
    }
  }
}
