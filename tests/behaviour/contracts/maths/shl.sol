pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function shl8safe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs << rhs;
  }

  function shl8unsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl8_256safe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    return lhs << rhs;
  }

  function shl8_256unsafe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl256safe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    return lhs << rhs;
  }

  function shl256unsafe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl256_256safe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs << rhs;
  }

  function shl256_256unsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl8signedsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    return lhs << rhs;
  }

  function shl8signedunsafe (uint8 lhs, uint8 rhs) pure public returns (uint8) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl8_256signedsafe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    return lhs << rhs;
  }

  function shl8_256signedunsafe (uint8 lhs, uint256 rhs) pure public returns (uint8) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl256signedsafe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    return lhs << rhs;
  }

  function shl256signedunsafe (uint256 lhs, uint8 rhs) pure public returns (uint256) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl256_256signedsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    return lhs << rhs;
  }

  function shl256_256signedunsafe (uint256 lhs, uint256 rhs) pure public returns (uint256) {
    unchecked {
      return lhs << rhs;
    }
  }

  function shl_positive_literal() pure public returns (bool) {
    return (4066 << 1) == 8132;
  }

  function shl_negative_literal() pure public returns (bool) {
    return (-4066 << 2) == -16264;
  }
}
