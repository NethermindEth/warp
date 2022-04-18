// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


function increment(uint256 x) pure returns (uint256) {
    return x + 1;
}

function decrement(uint256 y) pure returns (uint256) {
    return y - 1;
}

library Foo {
    function divideBy2(uint256 a) public pure returns (uint256) {
        return a/2;
    }
    function return2(uint256) public pure returns (uint256) {
        return 2;
    }
}

library Bar {
    function decrementBy2(uint256 a) public pure returns (uint256) {
        return a - 2;
    }
    function incrementBy2(uint256 a) public pure returns (uint256) {
        return a + 2;
    }
}


using Bar for uint256;

contract WARP{
    using {increment, decrement, Foo.divideBy2, Foo.return2} for uint256;
    uint256 public a = 3;
    function callOnIdentifierAdd() public view returns (uint256) {
        return a.increment() + a.decrement();
    }
    function callOnIdentifierMul() public view returns (uint256) {
        return a.divideBy2() * a.return2();
    }
    function callLibFunction() public view returns (uint256) {
        return a.decrementBy2();
    }
}
