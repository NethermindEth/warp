pragma solidity ^0.8.14;

// SPDX-License-Identifier: MIT

import './mathLib1.sol';

library A1 {
  using Addition for uint8;
  using Subtraction for uint8;

  function add(uint8 a, uint8 b) external pure returns (uint8) {
    return internal_add(a, b);
  }

  function internal_add(uint8 a, uint8 b) internal pure returns (uint8) {
    return Addition.add(a, b);
  }

  function sub(uint8 a, uint8 b) public pure returns (uint8) {
    return private_sub(a, b);
  }

  function private_sub(uint8 a, uint8 b) private pure returns (uint8) {
    return Subtraction.subtract(a, b);
  }

  function mul(uint8 a, uint8 b) external pure returns (uint8) {
    return a * b;
  }

  function div(uint8 a, uint8 b) public pure returns (uint8) {
    return a / b;
  }
}