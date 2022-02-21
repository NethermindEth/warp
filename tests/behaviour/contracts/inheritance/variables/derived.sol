pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

import './mid.sol';

contract Derived is Mid {
  function f() public returns (uint, uint) {
    return (super.g() + Base.g(), x);
  }
}
