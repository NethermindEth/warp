// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract WARP {

    mapping(uint => bool) oneDMap;
    mapping(uint => mapping(uint => bool)) twoDMap;

    function inIfExpression(uint8 x) public returns (uint8) {
      oneDMap[0] = false;
      if (!oneDMap[0]) {
        x = x + 1;
      }
      return x;
    }

    function inRequire(uint8 x) public returns (uint8) {
      twoDMap[0][0] = true;
      require(twoDMap[0][0]);
      x = x + 1;
      return x;
    }
}