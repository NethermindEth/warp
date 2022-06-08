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

  int16[] zz;

  function test(int8[4] calldata yy) external returns (int16, int16, int16, int16) {
    zz.push();
    zz = yy;
    return (zz[3], zz[2], zz[1], zz[0]);
  }

}