// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract WARP {
    uint public v;
    uint public k;

    function f() public {
        v=23;
        set({value: 234, key: 365});
    }

    function set(uint key, uint value) public {
        k = key;
        v = value;
    }
}