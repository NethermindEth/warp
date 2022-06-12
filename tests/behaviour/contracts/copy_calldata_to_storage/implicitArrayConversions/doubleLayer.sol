pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  // need to check small dim to larger size.
  // need to check small nBits to larger nBits
  // Static to Dynamic

  // Double layer - Signed, Source Static Static
  int16[3][2] b0; // <- int8[3][2]
  int16[][] b1;   // <- int8[3][2]
  int16[4][] b2;  // <- int8[3][2]
  int16[4][3] b3; // <- int8[3][2]
  int16[][3] b4;  // <- int8[3][2]
 
 // Double layer - Unsigned, Source Static Static
  uint[3][2] b5; // <- uint8[3][2]
  uint[][] b6;   // <- uint8[3][2]
  uint[4][] b7;  // <- uint8[3][2]
  uint[4][3] b8; // <- uint8[3][2]
  uint[][2] b9;  // <- uint8[3][3]
  
  // Double layer - Signed, Source Dynamic Static
  int16[3][] b10;  // <- int8[3][]
  int16[4][] b11;  // <- int8[3][]
  int16[][] b12;   // <- int8[3][]  
  
  // Double layer - Unsigned, Source Dynamic Static
  uint16[3][] b13; // uint8[3][]
  uint[3][] b14;  // <- uint8[3][]
  uint[4][] b15;  // <- uint8[3][]
  uint[][] b16;   // <- uint8[3][]


      //   int16[3][2] b0; // <- int8[3][2]
    function testb0(int8[3][2] calldata x) external returns (int16, int16, int16, int16, int16, int16) {
      b0 = x;
      return (b0[1][2], b0[1][1], b0[1][0], b0[0][2], b0[0][1], b0[0][0]);
    }

    //   int16[][] b1;   // <- int8[3][2]
    function testb1(int8[3][2] calldata x) external returns (int16, int16, int16, int16, int16, int16) {
      b1 = x;
      return (b1[1][2], b1[1][1], b1[1][0], b1[0][2], b1[0][1], b1[0][0]);
    }

    //   int16[4][] b2;  // <- int8[3][2]
    function testb2(int8[3][2] calldata x) external returns (int16, int16, int16, int16, int16, int16, int16, int16) {
      b2 = x;
      return (b2[1][3], b2[1][2], b2[1][1], b2[1][0], b2[0][3], b2[0][2], b2[0][1], b2[0][0]);
    }

    //   int16[4][3] b3; // <- int8[3][2] TODO
    function testb3(int8[3][2] calldata x) external returns (int16, int16, int16, int16, int16, int16, int16, int16, int16, int16, int16, int16) {
      b3 = x;
      return (b3[2][3], b3[2][2], b3[2][1], b3[2][0], b3[1][3], b3[1][2], b3[1][1], b3[1][0], b3[0][3], b3[0][2], b3[0][1], b3[0][0]);
    }

    //   int16[][3] b4;  // <- int8[3][2]
    function testb4(int8[3][2] calldata x) external returns (int16, int16, int16, int16, int16, int16) {
      b4 = x;
      return (b4[1][2], b4[1][1], b4[1][0], b4[0][2], b4[0][1], b4[0][0]);
    }

    //uint[3][2] b5; // <- uint8[3][2]
    function testb5(uint8[3][2] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
      b5 = x;
      return (b5[1][2], b5[1][1], b5[1][0], b5[0][2], b5[0][1], b5[0][0]);
    }

    //   uint[][] b6;   // <- uint8[3][2]
    function testb6(uint8[3][2] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
      b6 = x;
      return (b6[1][2], b6[1][1], b6[1][0], b6[0][2], b6[0][1], b6[0][0]);
    }
  
    //   uint[4][] b7;  // <- int8[3][2]
    function testb7(uint8[3][2] calldata x) external returns (uint, uint, uint, uint, uint, uint, uint, uint) {
      b7 = x;
      return (b7[1][3], b7[1][2], b7[1][1], b7[1][0], b7[0][3], b7[0][2], b7[0][1], b7[0][0]);
    }

    //   uint[4][3] b8; // <- int8[3][2]
    function testb8(uint8[3][2] calldata x) external returns (uint, uint, uint, uint, uint, uint, uint, uint) {
      b8 = x;
      return (b8[1][3], b8[1][2], b8[1][1], b8[1][0], b8[0][3], b8[0][2], b8[0][1], b8[0][0]);
    }

    //   uint[][3] b9;  // <- int8[3][2]
    function testb9(uint8[3][2] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
      b9 = x;
      return (b9[1][2], b9[1][1], b9[1][0], b9[0][2], b9[0][1], b9[0][0]);
    }

    //   int16[3][] b10;  // <- int8[3][]
    function testb10(int8[3][] calldata x) external returns (int16, int16, int16, int16, int16, int16) {
        b10 = x;
        return (b10[1][2], b10[1][1], b10[1][0], b10[0][2], b10[0][1], b10[0][0]);
    }

     //   int16[4][] b11;  // <- int8[3][]
    function testb11(int8[3][] calldata x) external returns (int16, int16, int16, int16, int16, int16) {
        b11 = x;
        return (b11[1][2], b11[1][1], b11[1][0], b11[0][2], b11[0][1], b11[0][0]);
    }

    //   int16[][] b12;   // <- int8[3][]  
    function testb12(int8[3][] calldata x) external returns (int16, int16, int16, int16, int16, int16) {
        b12 = x;
        return (b12[1][2], b12[1][1], b12[1][0], b12[0][2], b12[0][1], b12[0][0]);
    }
    
    //   uint16[3][] b13; // uint8[3][]
    function testb13(uint8[3][] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
        b13 = x;
        return (b13[1][2], b13[1][1], b13[1][0], b13[0][2], b13[0][1], b13[0][0]);
    }

    //   uint[3][] b14;  // <- uint8[3][]
    function testb14(uint8[3][] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
        b14 = x;
        return (b14[1][2], b14[1][1], b14[1][0], b14[0][2], b14[0][1], b14[0][0]);
    }

    //  uint[4][] b15;  // <- uint8[3][]
    function testb15(uint8[3][] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
        b15 = x;
        return (b15[1][2], b15[1][1], b15[1][0], b15[0][2], b15[0][1], b15[0][0]);
    }
     //   int16[][] b12;   // <- int8[3][]  
    function testb16(uint8[3][] calldata x) external returns (uint, uint, uint, uint, uint, uint) {
        b16 = x;
        return (b16[1][2], b16[1][1], b16[1][0], b16[0][2], b16[0][1], b16[0][0]);
    }

}
