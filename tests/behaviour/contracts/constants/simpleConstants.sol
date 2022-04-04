// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
  uint16 X = 247;
  uint16 constant Y = 256;
  uint16 constant Z = 7;

  function getX() public view returns (uint16) {
    return X;
  }

  function stateVarOp() public view returns (uint16) {
    return Y - X;
  }

  function constantOp() public pure returns (uint16) {
    return Y - Z;
  }

  function pureOp() public pure returns (uint16) {
    return Y * 2;
  }

  function pureOpWithValue(uint16 a) public pure returns (uint16) {
    return Y + a;
  }

  function changeStateVar() external {
    X += Y;
  }

}
