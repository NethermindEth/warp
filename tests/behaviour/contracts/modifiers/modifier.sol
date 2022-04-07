// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
  uint256 limit = 100000;
  modifier cost(uint256 price) {
    if (price <= limit) {
      _;
    }
  }

  function f(uint256 value) public view cost(value) returns (uint256 result) {
    return limit - value;
  }
}
