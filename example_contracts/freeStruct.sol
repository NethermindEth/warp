pragma solidity ^0.8.10;
//SPDX-License-Identifier: MIT

struct S {
    uint id1;
    uint id2;
}

contract A {
    function x() public pure {
        S memory a = S(0,0);
    }
}
