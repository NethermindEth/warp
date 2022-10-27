pragma solidity ^0.8.6;

contract A {
  uint256 x = 0;

  modifier step(uint256 value) {
    x += value;
    _;
  }

  function f(uint256 amount) external step(amount) returns (uint256) {
    return x;
  }
}

contract B is A {}
