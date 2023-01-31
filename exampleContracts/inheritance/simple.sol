pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract Base {
  function f() pure external returns (uint8) {
    return 0;
  }

  function g() virtual pure external returns (uint8) {
    return 0;
  }
}

contract Derived is Base {
  function g() override pure external returns (uint8) {
    return 1;
  }
}
