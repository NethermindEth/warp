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

    constructor() public {
        a.a = 1;
        a.b = 2;
        b.a = 3;
        b.b = 4;
        c.a = 5;
        c.b = 6;
    }

}
