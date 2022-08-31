pragma solidity ^0.8;

contract TestFunction1 {
  uint256 x;

  constructor() {
    this.setVal(2);
  }

  function setVal(uint256 _x) external {
    x = _x;
  }
}
