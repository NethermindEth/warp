pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT
struct S {
    T[] x;
}

struct T {
    uint a;
}

contract WARP {
    function x(S memory y) pure external {
    }
}
