pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

abstract contract Base {
    constructor (mapping (uint => uint) storage m) {
        m[5] = 20;
    }
}

contract WARP is Base {
    mapping (uint => uint) public map;

    constructor() Base(map) {
    }
}
