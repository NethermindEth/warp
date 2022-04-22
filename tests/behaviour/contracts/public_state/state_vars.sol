// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

/*
To test whether getters functions are being generated correctly for public state variables.
*/

contract WARP{
    uint256 public x;
    uint256[2] public y;
    mapping(uint256 => uint256[5]) public z;
    uint256[2][2][2] public w;
    constructor() public{
        x = 10;
        y[0] = 12;
        z[0][0] = 13;
        z[0][1] = 14;
        w[0][0][0] = 15;
    }
}