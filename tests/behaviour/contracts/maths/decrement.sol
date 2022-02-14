pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function preDecrementStatement (uint8 op) pure public returns (uint8) {
    --op;
    return op;
  }

  function postDecrementStatement (uint8 op) pure public returns (uint8) {
    op--;
    return op;
  }

  function preDecrementExpression (uint8 op) pure public returns (uint8, uint8) {
    uint8 x = --op;
    return (x, op);
  }

  function postDecrementExpression (uint8 op) pure public returns (uint8, uint8) {
    uint8 x = op--;
    return (x, op);
  }
}
