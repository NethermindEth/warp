pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function unsignedNarrow() pure public returns (uint8, uint8, uint8, uint8) {
    uint8 a = type(uint8).max;
    uint8 b = 251;
    uint8 c = 0;
    uint8 d = type(uint8).min;
    return (a,b,c,d);
  }

  function signedNarrow() pure public returns (int8, int8, int8, int8, int8) {
    int8 a = type(int8).max;
    int8 b = 120;
    int8 c = 0;
    int8 d = -100;
    int8 e = type(int8).min;
    return (a,b,c,d,e);
  }

  function unsignedWide() pure public returns (uint256, uint256, uint256, uint256, uint256) {
    uint256 a = type(uint256).max;
    uint256 b = 2 ** 200 + 10;
    uint256 c = 251;
    uint256 d = 0;
    uint256 e = type(uint256).min;
    return (a,b,c,d,e);
  }

  function signedWide() pure public returns (int256, int256, int256, int256, int256, int256, int256) {
    int256 a = type(int256).max;
    int256 b = 2 ** 200 + 10;
    int256 c = 120;
    int256 d = 0;
    int256 e = -100;
    int256 f = -(2 ** 180) + 5;
    int256 g = type(int256).min;
    return (a,b,c,d,e,f,g);
  }
}
