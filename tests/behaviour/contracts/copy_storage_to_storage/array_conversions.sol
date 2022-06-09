pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

contract WARP {
  uint[] x;
  uint[2] y;

  function setStatic(uint a, uint b) external returns (uint[2] memory) {
    y = [a,b];
    return y;
  }

  function copyStaticToDynamic() external returns (uint[] memory, uint[2] memory) {
    x = y;
    return (x,y);
  }

  uint[][] a;
  uint[2][2] b;

  function setStaticDeep(uint i, uint j, uint k, uint l) external returns (uint[2][2] memory) {
    b = [[i,j], [k,l]];
    return b;
  }

  uint[3][3] bb;
  function copyStaticDifferentSize() external returns (uint[3][3] memory) {
    bb = b; 
    return bb;
  }

  function copyStaticDifferentSizeComplex() external returns (uint[3][3] memory) {
    bb = [[9, 9, 9], [10, 10, 10], [11, 11, 11]]; 
    bb = b;
    return bb;
  }

  function copyStaticToDynamicDeep() external returns (uint[] memory, uint[] memory, uint[2][2] memory) {
    a = b;
    return (a[0], a[1],b);
  }

  function copyStaticToDynamicPush() external returns (uint[] memory, uint[] memory, uint[] memory) {
      a = [[2, 3, 5], [7, 11, 13], [17, 19, 23]];
      a = b;
      a.push();
      return (a[0], a[1], a[2]);
  }

  uint[][2] c;
  function copyStaticStaticToStaticDynamic() external returns (uint[] memory, uint[] memory, uint[2][2] memory) {
    c = b;
    return (c[0], c[1], b);
  }

  uint[2][] d;
  function copyStaticStaticToDynamicStatic() external returns (uint, uint, uint, uint, uint[2][2] memory) {
    d = b;
    return (d[0][0], d[0][1], d[1][0], d[1][1], b);
  }

  uint8[] u8;
  uint256[] u256;
  function scalingUint(uint8[] memory m) external returns (uint256[] memory) {
    u8 = m;
    u256 = u8;
    return u256;
  }

  int8[] i8;
  int32[] i32;
  function scalingInt(int8[] memory m) external returns (int32[] memory) {
      i8 = m;
      i32 = i8;
      return i32;
  }

  function identity() external returns (uint8[] memory, uint256[] memory) {
      u8 = u8;
      u256 = u256;
      return (u8, u256);
  }
}
