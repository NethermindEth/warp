// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract Test {
  function foo(address payable to) public payable {
    (bool sent, ) = to.call{value: msg.value}('');
    require(sent, 'Failed to send Ether');
  }
}
