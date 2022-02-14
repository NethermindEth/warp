pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

library Nums {
  function amIReal(int256 t, bool d) external returns (bool) {
    return true;
  }
  function amIReal(uint256 t, bool d) external returns (bool) {
    return false;
  }
}

contract WARP {

  using Nums for uint256;

  function f(bool d) public payable returns (bool) {
    uint256 t = 0;
    bool g = Nums.amIReal(t, d);
    return t.amIReal(d);
  }
}
