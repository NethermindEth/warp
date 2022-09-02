// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract DeleteExample {
    struct A{
        uint a1;
        address a2;
    }

    function f() public view{
        uint x = 4;
        uint i = 6;
        while (i > 0){
            delete x;
            i--;
        }
        A memory a = A(5, address(this));
        delete a;
        return delete x;
    }
}