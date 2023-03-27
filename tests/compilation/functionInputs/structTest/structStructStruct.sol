pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT
struct A {
    B member1;
}

struct B {
  C member2;
}

struct C {
    int8 member3;
}
contract WARP {
    function inputFunc(A memory y) pure external {
    }
}