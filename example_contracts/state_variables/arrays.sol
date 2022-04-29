pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
 State variables of ArrayTypes formed with elementary types
*/

contract WARP {
    uint256[] public a;

    uint256[] b;
    uint256[] public c;

    address[] public d;

    bool[] public e;
    bool[][] public f;

    uint112[][][] public g;
    /*
    struct A{
        uint256 a;
        uint256 b;
    }
    A[] public h; This case will lead to an error 
    */
}
