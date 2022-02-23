// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

/*
To test whether getters functions are being generated correctly for public state variables.
*/

contract WARP{
    uint256 public x;
    constructor() public{
        x = 10;
    }

}