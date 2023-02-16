pragma solidity ^0.8;

contract T {
  constructor() {
    this.f();
  }

  function f() external {}
}

contract U {
  constructor() {
    this.f();
  }

  function f() external returns (uint256) {}
}

contract C {
  function f(uint256 c) external returns (uint256) {
    if (c == 0) new T();
    else if (c == 1) new U();
    return 1 + c;
  }
}
