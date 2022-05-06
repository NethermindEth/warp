pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT


contract WARP {
    enum A{
        A1,
        A2,
        A3
    }
    enum B{
        B1,
        B2,
        B3
    }
    A public a;
    A public b;
    B public c;
    B public d;
    A constant e = A.A2;
    A public f = A.A3;

    constructor() public {
        a = A.A1;
        b = A.A2;
        c = B.B1;
        d = B.B2;
    }
}
