pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function preIncrementStatement (uint8 op) pure public returns (uint8) {
    ++op;
    return op;
  }

  function postIncrementStatement (uint8 op) pure public returns (uint8) {
    op++;
    return op;
  }

  function preIncrementExpression (uint8 op) pure public returns (uint8, uint8) {
    uint8 x = ++op;
    return (x, op);
  }

  function postIncrementExpression (uint8 op) pure public returns (uint8, uint8) {
    uint8 x = op++;
    return (x, op);
  }
}
