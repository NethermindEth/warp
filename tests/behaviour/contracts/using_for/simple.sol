// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


function increment(uint256 x) pure returns (uint256) {
    return x + 1;
}

function decrement(uint256 y) pure returns (uint256) {
    return y - 1;
}

function triArgFunction(uint256 x, uint256 y, uint256 z) pure returns (uint256) {
    return x + y - z;
}

contract WARP{
    using {increment, decrement, triArgFunction} for uint256;
    uint256 public a = 3;
    function callOnIdentifier() public view returns (uint256) {
        return a.increment() + a.decrement();
    }
    function callOnFunctionCall() public pure returns (uint256) {
        return uint256(30).increment() + uint256(30).decrement(); 
    }
     function namedArgChecker() public pure returns (uint256) {
        return uint256(30).triArgFunction({z:34, y:66}); 
    }
}

