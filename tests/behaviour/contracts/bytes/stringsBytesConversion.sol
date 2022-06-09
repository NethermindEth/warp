pragma solidity ^0.8.14;

// SDPX-License-Identifier: MIT

contract WARP {
    string s;
    bytes b;

    function getCharacter(string memory _s, uint256 n) public returns (bytes1) {
        b = bytes(_s);
        s = string(b);
        return bytes(s)[n];
    }

    function getLength() public returns (uint256) {
        return bytes(s).length;
    }
}