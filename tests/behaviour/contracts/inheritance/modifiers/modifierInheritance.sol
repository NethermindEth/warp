// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract A {
  bool locked = false;

  modifier unlocked() {
    require(!locked, 'Can not call this function when locked');
    locked = true;
    _;
    locked = false;
  }

  function lock() public {
    locked = true;
  }
}

contract B is A {
  uint256 public balance;

  function clear() public {
    delete balance;
    delete locked;
  }
}

contract C {
  modifier costs(uint256 value, uint256 price) {
    if (value >= price) {
      _;
    }
  }
}

contract D is C, B {
  constructor() {
    balance = 100000;
  }

  function withdraw(uint256 price) public unlocked costs(balance, price) returns (uint256 result) {
    balance -= price;
    return balance;
  }
}
