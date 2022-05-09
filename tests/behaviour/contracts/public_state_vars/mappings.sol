pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
 State variables of Mapping Types formed with elementary types
*/

contract WARP {
    mapping(uint256 => int256) public a;
    mapping(uint256 => address) public b;
    mapping(uint128 => address) private c;
    mapping(bool => uint256) public d;
    mapping(address => mapping(uint256 => address)) public e;

    constructor() public {
        a[1] = 1;
        b[2] = 0x0000000000000000000000000000000000000001;
        c[3] = 0x0000000000000000000000000000000000000001;
        d[true] = 1;
        e[0x0000000000000000000000000000000000000001][1] = 0x0000000000000000000000000000000000000001;
    }
}
