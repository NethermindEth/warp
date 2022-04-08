pragma solidity ^0.8.0;

contract A {
  uint256 balance = 6000;

  modifier cost(uint256 value) virtual {
    require(value <= balance, 'Value to withdraw must be smaller than the current balance');
    _;
  }
}

contract B is A {
  uint256 limit = 200;

  modifier cost(uint256 value) override {
    require(value <= balance, 'Value to withdraw must be smaller than the current balance');
    require(value >= limit, 'Value to withdraw must be bigger than the limit');
    _;
  }
}

contract C is B {
  modifier rest() {
    _;
    require(balance >= 1000, 'Balance must be bigger than 1000');
  }

  function withdraw(uint256 price) public cost(price) rest returns (uint256) {
    balance -= price;
    return balance;
  }
}
