pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[5] x = [1, 2, 3, 4, 5];
  uint8[15] y;

  constructor() {
      y[0] = 5;
      y[5] = 10;
      y[10] = 15;
      y[14] = 17;
  }

  function getX()  public view returns (uint8[5] memory) {
    return x;
  }

  function getY() public view returns (uint8[15] memory) {
    return y;
  }
}
