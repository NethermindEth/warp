// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract A {
  uint256 data;

  fallback() external {
    data = 1;
  }

  function getData() public view returns (uint256 r) {
    return data;
  }
}

contract B is A {}
