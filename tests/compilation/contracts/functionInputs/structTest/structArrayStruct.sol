pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT
struct S {
    C[3] x;
}

struct C {
    int8 member3;
}

contract WARP {
    function x(S memory y) pure external {
    }
}
