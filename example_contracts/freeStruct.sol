pragma solidity ^0.8.10;
//SPDX-License-Identifier: MIT

struct S {
    uint id1;
    uint id2;
}

contract A {
    function x(S memory _input) public pure {
        S memory a = S(_input.id1, _input.id2);
    }
}
