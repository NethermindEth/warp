
pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract A{
    uint a;
    function f() public returns (uint) {
        a = 69;
        return a;
    }
}

contract WARP{
    function f(address addr) public returns (uint){
        return A(addr).f();
    }
}
