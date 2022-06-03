
pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

contract WARP {
    function s0() public pure returns(string memory) {
        string memory m = string.concat();
        return m;
    }
    function s1(string memory x1) public pure returns(string memory) {
        string memory m = string.concat(x1);
        return m;
    }
    function s2(string memory x1, string memory x2) public pure returns(string memory) {
        string memory m = string.concat(x1, x2);
        return m;
    }
    function s3(string memory x1, string memory x2, string memory x3) public pure returns(string memory) {
        string memory m = string.concat(x1, x2, x3);
        return m;
    }
}
