pragma solidity ^0.8.14;

interface F {
    function A(uint[] storage x) external pure;
}

contract C {
    function f(address x) external pure {
        uint[] memory dynArray1 = new uint[](3);
        F(x).A(dynArray1);
    }
}