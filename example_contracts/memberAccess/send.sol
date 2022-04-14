// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract Test {
  function foo(address payable to) public payable returns (bool) {
    bool sent = to.send(msg.value);
    return sent;
  }
}
