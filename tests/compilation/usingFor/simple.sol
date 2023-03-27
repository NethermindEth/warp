// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


function f(uint256 x) pure returns (uint256) {
    return x + 1;
}

function g(uint256 y) pure returns (uint256) {
    return y - 1;
}

function h(uint256 x, uint256 y, uint256 z) pure returns (uint256) {
    return x + y - z;
}


contract WARP{
    using {f, g, h} for uint256;
    uint256 public a = 3;
    function bar() public view returns (uint256) {
        return a.f() + a.g();
    }
    function fum() public pure returns (uint256) {
        return uint256(30).f() + uint256(30).g(); 
    }
    function hat() public pure returns (uint256) {
        return uint256(30).h({z:34, y:66}); 
    }
}
