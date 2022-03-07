pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

import "./mid.sol";

contract Derived is Mid {
  function f() pure public returns (uint8) {
    return super.g() + Base.g();
  }
}
