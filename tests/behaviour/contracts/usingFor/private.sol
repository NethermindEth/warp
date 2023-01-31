// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


library Nums {
  function foo(uint256 a, uint x) private pure returns (uint) {
    return a*x;
  }
}

// using Nums for uint;

contract WARP{
    using {Nums.foo} for uint256;
    function callOnIdentifier(uint x, uint y) public returns (uint) {
        return x.foo(y);
    }
}
