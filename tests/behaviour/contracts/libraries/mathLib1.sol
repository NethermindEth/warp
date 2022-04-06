pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

library Addition {
  function add(uint8 x, uint8 y) pure external returns (uint8) {
    return x+y;
  }
}

library Subtraction {
  function subtract(uint8 x, uint8 y) pure external returns (uint8) {
    return x-y;
  }
}
