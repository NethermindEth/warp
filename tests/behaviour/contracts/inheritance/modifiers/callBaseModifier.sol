// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
  modifier price(uint256 value) virtual{
    require(value < 10, 'Failed call to base modifier');
    _;
  }
}

contract B is A {
  modifier price(uint256 value) override {
    require(value < 100);
    _;
  }
  function f(uint256 value) public pure A.price(value) returns (uint256){
    return 2;
  }
  function g(uint256 value) public pure price(value) returns (uint256){
    return 2;
  }
}
