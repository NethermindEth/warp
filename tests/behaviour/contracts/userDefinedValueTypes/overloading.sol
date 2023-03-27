pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  type A is uint8;

  function f(A a) internal returns (uint8) {
    return A.unwrap(a) + 1;
  }

  function f(uint8 a) internal returns (uint8) {
    return a;
  }

  function callOverloads(uint8 a) public returns (uint8, uint8) {
    A wrapped = A.wrap(a);
    return (f(a), f(wrapped));
  }
}
