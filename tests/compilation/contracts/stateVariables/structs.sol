pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    struct A{
        uint256 a;
        uint256 b;
    }

    A public a;
    A private b;
    A public c;
}
