pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT
struct A {
    B member1;
}

struct B {
  bytes a;
}

contract WARP {
    function inputFunc() pure external returns (A memory) {
    }
}
