// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


function f(uint256 x) pure returns (uint256) {
    return x + 1;
}

function g(uint256 y) pure returns (uint256) {
    return y - 1;
}

contract WARP{
    using {f, g} for uint256;
    uint256 public a = 3;
    function bar() public view returns (uint256) {
        return a.f() + a.g();
    }
}