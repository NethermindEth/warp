// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;



function foo(function(uint) pure returns (uint) param, uint x) pure returns (uint) {
    return param(x);
}

contract WARP{
    using { foo } for function(uint256) pure returns (uint256);
    
    function baz(uint x) public pure returns (uint) {
        return x**2;
    }
    function ham(uint x) public pure returns (uint) {
        return baz.foo(x);
    }
    function qux(uint x) public pure returns (uint) {
        return foo(baz, x);
    }
}
