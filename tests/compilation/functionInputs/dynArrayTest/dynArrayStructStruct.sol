pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT
struct A {
    B member1;
}

struct B {
  uint8 a;
}

contract WARP {
    function inputFunc(A[] memory y) pure external {
    }
}