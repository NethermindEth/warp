pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

abstract contract A {
  function f() public view virtual returns (uint256);

  function g() public view virtual returns (uint256) {
    return 10;
  }
}

abstract contract B is A {
  function g() public view override returns (uint256) {
    return f();
  }
}

contract C is B {
  function f() public pure override returns (uint256) {
    return 30;
  }
}
