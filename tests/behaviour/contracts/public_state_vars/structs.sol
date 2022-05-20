pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    struct A{
        uint256 a;
        uint256 b;
    }

    struct B{
        uint256 a;
        address b;
        int120 c;
        A d;
    }

    A public a;
    A private b;
    A public c;

    B public d;

    constructor() public {
        a.a = 1;
        a.b = 2;
        b.a = 3;
        b.b = 4;
        c.a = 5;
        c.b = 6;

        d.a = 7;
        d.b = address(0x1234567890123456789012345678901234567890);
        d.c = 9;
        d.d.a = 10;
        d.d.b = 11;
    }
}
