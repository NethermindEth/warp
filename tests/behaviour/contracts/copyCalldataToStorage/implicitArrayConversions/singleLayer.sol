pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  // need to check small dim to larger size.
  // need to check small nBits to larger nBits
  // Static to Dynamic

  // Single layer - Signed, Source Static
  //Check with dom if int8[3] -> int16[3]
  int[] a0;   // <- int8[3]
  int16[] a1; // <- int8[3]
  int[5] a2; // <- int8[3]
  // Single layer - Unsigned, Source Static
  uint16[] a3; // uint8[];
  uint[] a4; // uint8[3]
  uint[5] a5; // <- uint16[3]
  
  // Single layer - Signed, Source Dynamic
  int[] a6; // <- int8[]
  // Single layer - Unsigned, Source Dynamic
  uint[] a7; // <- uint8[]  
  
  function testa0(int8[3] calldata x) external returns (int, int, int){
      a0 = x;
      return (a0[2], a0[1], a0[0]);
    }

    function testa1(int8[3] calldata x) external returns (int16, int16, int16) {
      a1 = x;
      return (a1[2], a1[1], a1[0]);
    }

    function testa2(int8[3] calldata x) external returns (int, int, int, int, int) {
      a2 = x;
      return (a2[4], a2[3], a2[2], a2[1], a2[0]);
    }

    function testa3(uint8[] calldata x) external returns (uint16, uint16, uint16) {
      a3 = x;
      return (a3[2], a3[1], a3[0]);
    }

    function testa4(uint8[3] calldata x) external returns (uint, uint, uint) {
      a4 = x;
      return (a4[2], a4[1], a4[0]);
    }

    function testa5(uint16[3] calldata x) external returns (uint, uint, uint, uint, uint) {
      a5 = x;
      return (a5[4], a5[3], a5[2], a5[1], a5[0]);
    }
  
    function testa6(int8[] calldata x) external returns (int, int, int, int) {
      a6 = x;
      return (a6[3], a6[2], a6[1], a6[0]);
    }
  
    // uint[] a7; // <- uint8[]
    function testa7(uint8[] calldata x) external returns (uint, uint, uint, uint) {
      a7 = x;
      return (a7[3], a7[2], a7[1], a7[0]);
    }
  
}
