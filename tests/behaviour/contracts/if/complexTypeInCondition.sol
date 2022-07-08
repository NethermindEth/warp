// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract WARP {

    bool[1] oneDArr;
    bool[1][1] twoDArr;
    mapping(uint => bool) oneDMap;
    mapping(uint => mapping(uint => bool)) twoDMap;

    function arr1DInIfExpression(uint8 x) public returns (uint8) {
      oneDArr[0] = false;
      if (!oneDArr[0]) {
        x = x + 1;
      }
      return x;
    }

    function map1DInIfExpression(uint8 x) public returns (uint8) {
      oneDMap[0] = false;
      if (!oneDMap[0]) {
        x = x + 1;
      }
      return x;
    }

    function arr2DInIfExpression(uint8 x) public returns (uint8) {
      twoDArr[0][0] = true;
      if (twoDArr[0][0]) {
        x = x + 1;
      }
      return x;
    }

    function map2DInIfExpression(uint8 x) public returns (uint8) {
      twoDMap[0][0] = true;
      if (twoDMap[0][0]) {
        x = x + 1;
      }
      return x;
    }

    function nestedExpressions(uint8 x) public returns (uint8) {
      oneDArr[0] = true;
      twoDArr[0][0] = true;
      oneDMap[0] = false;
      twoDMap[0][0] = false;
      if((oneDArr[0] && oneDMap[0]) || (twoDMap[0][0] && twoDArr[0][0])) {
        x = x + 1;
      }
      return x;
    }
}