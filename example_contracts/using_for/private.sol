// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


library Nums {
  function foo(uint256 a) private pure returns (bool) {
    return true;
  }
}

// using Nums for uint;

contract A{
    using {Nums.foo} for uint256;
    function foo(uint x) public returns (bool) {
        return x.foo();
    }
}