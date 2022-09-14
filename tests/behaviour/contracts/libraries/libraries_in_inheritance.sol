pragma solidity ^0.8.14;

library A1 {
  function f(uint256 a, uint256 b) internal view returns (uint256) {
    return a + b;
  }
}

library A2 {
  function h(uint256 c, uint256 d) internal {}
}

contract B {
  using A1 for uint256;
  uint256 val;

  function g() external returns (uint256) {
    A2.h(1, 2);
    return val.f(1);
  }
}

contract C is B {
  using A1 for uint256;

  function debug() external view {
    uint256 a = 0;
    a.f(1);
  }
}
