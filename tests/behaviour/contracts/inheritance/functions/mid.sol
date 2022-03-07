pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

import './base.sol';

contract Mid is Base {
  function g(uint8 x) override pure public returns (uint8) {
    return x*2;
  }
}
