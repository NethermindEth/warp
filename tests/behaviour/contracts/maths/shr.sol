pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function shr8safe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs >> rhs;
  }

  function shr8unsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr8_256safe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    return lhs >> rhs;
  }

  function shr8_256unsafe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr256safe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    return lhs >> rhs;
  }

  function shr256unsafe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr256_256safe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs >> rhs;
  }

  function shr256_256unsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr8signedsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs >> rhs;
  }

  function shr8signedunsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr8_256signedsafe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    return lhs >> rhs;
  }

  function shr8_256signedunsafe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr256signedsafe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    return lhs >> rhs;
  }

  function shr256signedunsafe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr256_256signedsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs >> rhs;
  }

  function shr256_256signedunsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs >> rhs;
    }
  }

  function shr_positive_literal() pure public returns (bool) {
    return (4066 >> 1) == 2033;
  }

  function shr_negative_literal() pure public returns (bool) {
    return (-4066 >> 2) == -1017;
  }
}
