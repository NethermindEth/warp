pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

struct S {
    uint x;
    uint8 y;
}

contract WARP {

    function elemInt(uint8[] calldata x) pure external returns (uint8) {
        return x[0];
    }

    function elemStruct(S[] calldata x) pure external returns (S calldata) {
        return x[0];
    }
    
}
