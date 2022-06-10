pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  // need to check small dim to larger size.
  // need to check small nBits to larger nBits
  // Static to Dynamic

  int16[][] z1;   // <- int8[3][2]
  int16[2][] z2;  // <- int8[3][2]
  int16[2][2] z3; // <- int8[3][2]
  int16[][2] z4;  // <- int8[3][2]


  int16[] y3;     // <- int8[]
  int16[2][] y4;  // <- int8[2][]
  int16[][] y5;   // <- int8[2][]

  function testA1(int8[] calldata yy) external returns (int16, int16, int16, int16) {
      y3 = yy;
      return (y3[3], y3[2], y3[1], y3[0]);
  }

  function testA2(int8[2][] calldata yy) external returns (int16, int16, int16, int16) {
      y4 = yy;
      return (y4[1][1], y4[1][0], y4[0][1], y4[0][0]);
  }

  function testA3(int8[2][] calldata yy) external returns (int16, int16, int16, int16){
      y5 = yy;
      return (y5[1][1], y5[1][0], y5[0][1], y5[0][0]);
  }


  function testZ1(int8[2][2] calldata yy) external returns (int16, int16, int16, int16){
    z1 = yy;
    return (z1[1][1], z1[1][0], z1[0][1], z1[0][0]);
  }

  function testZ2(int8[2][2] calldata yy) external returns (int16, int16, int16, int16){
    z2 = yy;
    return (z2[1][1], z2[1][0], z2[0][1], z2[0][0]);
  }

  function testZ3(int8[2][2] calldata yy) external returns (int16, int16, int16, int16){
    z3 = yy;
    return (z3[1][1], z3[1][0], z3[0][1], z3[0][0]);
  }

  function testZ4(int8[2][2] calldata yy) external returns (int16, int16, int16, int16){
    z4 = yy;
    return (z4[1][1], z4[1][0], z4[0][1], z4[0][0]);
  }

}