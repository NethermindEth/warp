// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract Test {
  function foo(address to) public view returns (uint256) {
    return to.balance;
  }
}
