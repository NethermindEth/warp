// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract Test {
  function foo(address payable to) public view returns (bool) {
    (bool res, ) = to.staticcall('');
    return res;
  }
}
