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
    A a;
    A public b;
    B c;
    B public d;
    A constant e = A.A2;
    A public f = A.A3;
}
