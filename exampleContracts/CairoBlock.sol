// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.14;

// Learn more about Cairo Blocks here: 
// https://nethermindeth.github.io/warp/docs/features/cairo_stubs

contract Example {

  ///warp-cairo
  ///DECORATOR(external)
  ///func CURRENTFUNC()(lhs: felt, rhs: felt) -> (res: felt) {
  ///    if (lhs == 0) {
  ///        return (res=rhs);
  ///    } else {
  ///        return CURRENTFUNC()(lhs - 1, rhs + 1);
  ///    }
  ///}
  function recursiveAdd(uint8 lhs, uint8 rhs) pure external returns (uint8) {
    return 0;
  }
}