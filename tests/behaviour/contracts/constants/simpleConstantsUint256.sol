// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
  uint X = 2 ** 255 + 2 ** 254;
  uint constant XX = 2 ** 255 + 2 ** 250;
  uint constant Y = 2 ** 256 - 1;
  int constant Z = -1;

  function getX() public view returns (uint) {
    return X;
  }

  function stateVarOp() public view returns (uint) {
    return Y - X;
  }

  function constantOp() public pure returns (uint) {
    return Y - XX;
  }

  function pureOp() public pure returns (uint) {
    return Y / 5;
  }

  function pureOpWithValue(uint a) public pure returns (uint) {
    return Y - a;
  }

  function pureOpWithValueTwo(int a) public pure returns (int) {
    int zz = Z + a;
    return zz;
  }

  function changeStateVar() external {
    X = Y - 2 ** 200;
  }

}
