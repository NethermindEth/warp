// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

function f(int256 x) pure returns (int256) {
    return x;
}

library Test {
  function foo(int256 a) private pure returns (int256) {
    return f(a);
  }
}

contract A{
    using { Test.foo } for int256;
    function foo(int256 x) public returns (int256) {
        return x.foo();
    }
}
