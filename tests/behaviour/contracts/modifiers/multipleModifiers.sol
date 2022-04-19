// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract WARP {
  uint256 public balance = 0;
  bool open = false;

  modifier cost(uint256 value) {
    require(value >= 100, 'Value for donation must be bigger than 100');
    _;
  }

  modifier isOpen() {
    require(open, 'The event must be open in order to receive donations');
    _;
  }

  function donate(uint256 value) public isOpen cost(value) returns (uint256 result) {
    balance += value;
    return balance;
  }

  function openEvent() public {
    open = true;
  }

  function closeEvent() public {
    open = false;
    balance = 0;
  }
}
