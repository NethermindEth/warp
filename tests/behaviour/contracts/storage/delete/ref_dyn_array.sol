pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

contract WARP {
    struct Simple  {
        uint8 a;
        uint8 b;
        uint8 c;
    }
    Simple[] z;
    Simple[] w;

    constructor() {
        z.push(Simple(7, 8, 9));
        z.push(Simple(10, 11, 12));
    }

    function tryDeleteZ() public returns (Simple memory) {
        Simple storage s = z[0];
        delete z;
        return s;
    }
}

