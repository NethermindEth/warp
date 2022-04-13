// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract Test {
  function foo(address to) public view returns (bytes32) {
    return to.codehash;
  }
}
