pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

import "./base.sol";

contract Mid is Base {
  function g() override pure public returns (uint8) {
    return 1;
  }
}
