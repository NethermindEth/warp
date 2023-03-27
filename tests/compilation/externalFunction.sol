
pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract A{
    uint a;
    function f() public {
        a = 2;
    }
}
contract B{
    A public b;
    struct AA{
        uint x;
        uint y;
    }
}
contract C{
    B public a;
    function foo() public{
        a.b().f();
    }
    function bar(address addr) public{
        B c = B(addr);
        c.b().f();
    }
    function boo(address addr) public{
        B(addr).b().f();
    }
}
