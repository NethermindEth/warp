// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract WARP {

    bool[1] oneDArr;
    bool[1][1] twoDArr;

    function inIfExpression(uint8 x) public returns (uint8) {
      oneDArr[0] = false;
      if (!oneDArr[0]) {
        x = x + 1;
      }
      return x;
    }

    function inRequire(uint8 x) public returns (uint8) {
      twoDArr[0][0] = true;
      require(twoDArr[0][0]);
      x = x + 1;
      return x;
    }
}