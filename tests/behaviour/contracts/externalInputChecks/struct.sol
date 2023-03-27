pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

struct S {
    uint x;
    uint8 y;
}

struct T {
    uint8 a;
    S b;
}

struct U {
    uint8 a;
    uint8[3] b;
}

contract WARP {

    function memberInts(S calldata s) pure external returns (uint8) {
        return s.y;
    }

    function memberStructs(T calldata t) pure external returns (uint8) {
        return t.a;
    }
    
    function memberStaticArray(U calldata u) pure external returns (uint8) {
        return u.a;
    }
}
