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
}
