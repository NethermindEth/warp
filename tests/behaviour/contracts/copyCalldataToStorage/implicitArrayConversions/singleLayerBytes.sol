pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP { 
  // bytes4 -> bytes8
  // 10 -> 42949672960
  // 20 -> 85899345920
  // 30 -> 128849018880
  // 40 -> 171798691840

  // bytes4 -> bytes32
  // 10 -> 792281625142643375935439503360
  // 20 -> 1584563250285286751870879006720
  // 30 -> 2376844875427930127806318510080
  // 40 -> 3169126500570573503741758013440
  bytes4[4] by0;  //bytes4[3]
  bytes4[]  by1;   //bytes4[3]
  bytes4[]  by2;   // bytes4[]

  bytes8[4] by3;   //bytes4[3]
  bytes8[]  by4;   //bytes4[3]
  bytes8[]  by5;   // bytes4[]

  bytes32[4] by6;   //bytes4[3]
  bytes32[]  by7;   //bytes4[3]
  bytes32[]  by8;   // bytes4[]

  function testby0(bytes4[3] calldata x) external returns (bytes4, bytes4, bytes4){
      by0 = x;
      return (by0[2], by0[1], by0[0]);
    }

  function testby1(bytes4[3] calldata x) external returns (bytes4, bytes4, bytes4){
      by1 = x;
      return (by1[2], by1[1], by1[0]);
    }
  
  function testby2(bytes4[] calldata x) external returns (bytes4, bytes4, bytes4){
      by2 = x;
      return (by2[2], by2[1], by2[0]);
    }
    
  function testby3(bytes4[3] calldata x) external returns (bytes8, bytes8, bytes8){
      by3 = x;
      return (by3[2], by3[1], by3[0]);
    }
  

  function testby4(bytes4[3] calldata x) external returns (bytes8, bytes8, bytes8){
      by4 = x;
      return (by4[2], by4[1], by4[0]);
    }
  
  function testby5(bytes4[] calldata x) external returns (bytes8, bytes8, bytes8){
      by5 = x;
      return (by5[2], by5[1], by5[0]);
    }
  
  function testby6(bytes4[3] calldata x) external returns (bytes32, bytes32, bytes32){
      by6 = x;
      return (by6[2], by6[1], by6[0]);
    }

  function testby7(bytes4[3] calldata x) external returns (bytes32, bytes32, bytes32){
      by7 = x;
      return (by7[2], by7[1], by7[0]);
    }

  function testby8(bytes4[] calldata x) external returns (bytes32, bytes32, bytes32){
      by8 = x;
      return (by8[2], by8[1], by8[0]);
    }
}
