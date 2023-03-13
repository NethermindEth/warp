pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
  function inputTest(int8 a, int16 b, int32 c, int256 d) private pure returns (int256) {
    return a + b + c + d;
  }

  function main() public pure {
    int8 x = 1;
    int8 y = 1;
    inputTest(x, y, 2, 3);
  }
}
