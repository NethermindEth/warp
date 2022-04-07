
pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract A{
    uint a;
    function f() public returns (uint) {
        a = 696;
        return a;
    }
}
contract B{
    A public b;
    struct AA{
        uint x;
        uint y;
    }
    function setA(address addr) public {
        b = A(addr);
    }
}
contract C{
    B public a;
    function foo() public returns (uint){
        return a.b().f();
    }
    function setB(address addrA, address addrB) public {
        a = B(addrB);
        a.setA(addrA);
    }
    function f(address addr) public returns (uint){
        return A(addr).f();
    }
}
