pragma solidity ^0.8.10;
//SPDX-License-Identifier: MIT
contract WARP {
  type A is uint256;
  function f(A a) pure internal returns (A) {
    return a;
  }
  function g(A a) pure internal returns (A) {
    return f(a);
  }
}