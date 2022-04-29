pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
 State variables of ArrayTypes formed with elementary types
*/

contract WARP {
    uint256[] public a;

    address[] public d;

    bool[] public e;
    bool[][3] public f;

    uint112[][][] public g;

    uint256[2] public y;

    uint256[2][2][2] public w;

    constructor() {
        a.push(1);
        a.push(2);
        a.push(3);
        
        d.push(address(0x1234567890123456789012345678901234567890));
        d.push(address(0x1234567890123456789012345678901234567891));
        
        e.push(true);
        e.push(false);
        e.push(true);

        y[0] = 12;
    
        w[0][0][0] = 15;
        w[0][0][1] = 16;
    }
}