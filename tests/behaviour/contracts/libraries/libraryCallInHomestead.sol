pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

library Lib { function m() public view returns (address) { return msg.sender; } }

contract WARP {
    address public sender;
    function f() public {
        sender = Lib.m();
    }
}

