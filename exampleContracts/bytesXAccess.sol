pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
    bytes17 a;
    bytes18 b;

    // function to return a byte at index access of a
    function get1(uint256 index) public view returns (bytes1) {
        return a[index];
    }

    // function to return a byte at index access of a
    function get2(uint112 index) public view returns (bytes1) {
        return a[index];
    }

    // function to return a byte at index access of b
    function get3(uint256 index) public view returns (bytes1) {
        return b[index];
    }

    // function to return a byte at index access of b
    function get4(uint112 index) public view returns (bytes1) {
        return b[index];
    }

}
