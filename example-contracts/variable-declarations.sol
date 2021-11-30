pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  struct S {
    uint256 b;
  }
  struct T {
    S s;
    bool f;
  }
  struct U {
    S s;
    T t;
    S[] sarr;
  }

  function test()
    public
    pure
    returns (
      uint8,
      uint8,
      uint8
    )
  {
    uint256[] memory m;
    S memory s;
    T memory t;
    U memory u;
    uint8 a = 4;
    (uint8 b, uint8 c) = (3, 4);
    return (a, b, c);
  }
}
