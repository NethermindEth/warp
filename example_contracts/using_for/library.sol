// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


function f(uint256 x) pure returns (uint256) {
    return x + 1;
}

function g(uint256 y) pure returns (uint256) {
    return y - 1;
}

library Foo {
    function foo(uint256 a) public pure returns (uint256) {
        return a/2;
    }
    function bar(uint256) public pure returns (uint256) {
        return 2;
    }
}

library Bar {
    function baz(uint256 a) public pure returns (uint256) {
        return a - 2;
    }
    function fum(uint256 a) public pure returns (uint256) {
        return a + 2;
    }
}


using Bar for uint256;

contract WARP{
    using {f, g, Foo.foo, Foo.bar} for uint256;
    uint256 public a = 3;
    function foo() public view returns (uint256) {
        return a.f() + a.g();
    }
    function bar() public view returns (uint256) {
        return a.foo() * a.bar();
    }
    function baz() public view returns (uint256) {
        return a.baz();
    }
}