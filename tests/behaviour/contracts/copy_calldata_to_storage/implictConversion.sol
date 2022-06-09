pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
//   int16[2][3] x;
//   uint256[2][3] z;

//   function testSigned(int8[2][2] calldata y) external returns (int16, int16, int16, int16) {
//     x = y;
//     return (x[1][1], x[1][0], x[0][1], x[0][0]);
//   }

//   function testUint256(uint[2][2] calldata y) external returns (uint, uint, uint, uint){
//       z = y;
//       return (z[1][1], z[1][0], z[0][1], z[0][0]);
//   }

// [1,1,2,3,4]

//   int16[][2] zz;

//   function test() external {
//     int16[] memory x = new int16[](1);
//     int16[] memory z = new int16[](1);
    
//     int16[][2] memory yy = [x, z];

//     zz = yy;
//   }

  //int16[][][] zz;
//   int16[][] z1;   // tick
  int16[2][] z2;  // now
  int16[2][2] z3; // tick
  int16[][2] z4;  // tick
  
  function testZ2(int8[2][2] calldata yy) external returns (int16, int16, int16, int16){
    z2 = yy;
    return (z3[1][1], z3[1][0], z3[0][1], z3[0][0]);
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