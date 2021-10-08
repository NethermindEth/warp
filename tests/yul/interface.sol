pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

interface ICounter {
    function count() external view returns (uint, uint blah);
    function increment() external;
    function approve(uint guy, uint wad, uint sender) external returns (bool);
}

contract WARP {
}