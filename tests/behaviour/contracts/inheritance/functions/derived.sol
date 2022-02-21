pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

import './mid.sol';

contract Derived is Mid {
  function f(uint8 x) pure public returns (uint8) {
    return super.g(x) + Base.g(x);
  }
}
