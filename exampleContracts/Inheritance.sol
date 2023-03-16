//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;


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
