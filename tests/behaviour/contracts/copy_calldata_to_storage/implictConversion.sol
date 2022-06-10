pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  // need to check small dim to larger size.
  // need to check small nBits to larger nBits
  // Static to Dynamic

  // Single layer - Signed, Source Static
  //Check with dom if int8[3] -> int16[3]
  int16[] a1; // <- int8[3]
  int16[5] a2; // <- int8[3]
  // Single layer - Unsigned, Source Static
  uint16[] a3; // uint8[];
  uint[] a4; // uint8[3]
  uint[5] a5; // <- uint16[3]
  
  // Single layer - Signed, Source Dynamic
  int16[] a6; // <- int8[]
  // Single layer - Unsigned, Source Dynamic
  uint[] a7; // <- uint8[]

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

  // Triple Layered - Signed, Source Dynamic Static Static
  int8[2][2][] c0;     // int8[2][2][]
  int8[][][] c1;        // int8[2][2][]
  int8[4][4][] c2;     // int8[2][2][]
  int8[][4][] c3;      // int8[2][2][]
  int8[4][][] c4;      // int8[2][2][]
  
  // Triple Layered - Signed, Source Dynamic Static Static
  int8[4][3][3] c5;    // int8[2][2][2]
  int8[][][] c6;        // int8[2][2][2]
  int8[4][4][4] c7;    // int8[2][2][2]
  int8[][4][] c8;      // int8[2][2][2]
  int8[4][][] c9;      // int8[2][2][2]
  int8[3][4][3] c10;   // int8[2][2][2]


    function testa1(int8[3] calldata x) external returns (int16, int16, int16) {
      a1 = x;
      return (a1[2], a1[1], a1[0]);
    }

    function testa2(int8[3] calldata x) external returns (int16, int16, int16, int16, int16) {
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
  
    function testa6(int8[] calldata x) external returns (int16, int16, int16, int16) {
      a6 = x;
      return (a6[3], a6[2], a6[1], a6[0]);
    }
  
    // uint[] a7; // <- uint8[]
    function testa7(uint8[] calldata x) external returns (uint, uint, uint, uint) {
      a7 = x;
      return (a7[3], a7[2], a7[1], a7[0]);
    }


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

    //   // Triple Layered - Signed, Source Dynamic Static Static
    //   int8[2][2][] c0;     // int8[2][2][]
    function testc0(int8[2][2][] calldata x) external returns (int8[2][2] memory, int8[2][2] memory) {
        c0 = x;
        return (c0[1], c0[0]);
    }

    //   int[][][] c1;        // int8[2][2][]
    function testc1(int8[2][2][] calldata x) external returns (int8[] memory, int8[] memory, int8[] memory, int8[] memory) {
        c1 = x;
        return (c1[1][1], c1[1][0], c1[0][1], c1[0][0]);
    }

    //   int8[4][4][] c2;     // int8[2][2][]
    function testc2(int8[2][2][] calldata x) external returns (int8[4] memory, int8[4] memory, int8[4] memory, int8[4] memory) {
        c2 = x;
        return (c2[1][1], c2[1][0], c2[0][1], c2[0][0]);
    }

    //   int8[][4][] c3;      // int8[2][2][]
    function testc3(int8[2][2][] calldata x) external returns (int8[] memory, int8[] memory, int8[] memory, int8[] memory) {
        c3 = x;
        return (c3[1][1], c3[1][0], c3[0][1], c3[0][0]);
    }

    //   int8[4][][] c4;      // int8[2][2][]
    function testc4(int8[2][2][] calldata x) external returns (int8[4] memory, int8[4] memory, int8[4] memory, int8[4] memory) {
        c4 = x;
        return (c4[1][1], c4[1][0], c4[0][1], c4[0][0]);
    }

    //   // Triple Layered - Signed, Source Dynamic Static Static
    //   int8[3][3][4] c5;    // int8[2][2][2]
    function testc5(int8[2][2][2] calldata x) external returns (int8[4] memory, int8[4] memory, int8[4] memory, int8[4] memory) {
        c5 = x;
        return (c5[1][1], c5[1][0], c5[0][1], c5[0][0]);
    }

    //   int8[][][] c6;        // int8[2][2][2]
    function testc6(int8[2][2][2] calldata x) external returns (int8[] memory, int8[] memory, int8[] memory, int8[] memory) {
        c6 = x;
        return (c6[1][1], c6[1][0], c6[0][1], c6[0][0]);
    }
    //   int8[4][4][4] c7;    // int8[2][2][2]
    function testc7(int8[2][2][2] calldata x) external returns (int8[4] memory, int8[4] memory, int8[4] memory, int8[4] memory) {
        c7 = x;
        return (c7[1][1], c7[1][0], c7[0][1], c7[0][0]);
    }
    //   int8[][4][] c8;      // int8[2][2][2]
    function testc8(int8[2][2][2] calldata x) external returns (int8[] memory, int8[] memory, int8[] memory, int8[] memory) {
        c8 = x;
        return (c8[1][1], c8[1][0], c8[0][1], c8[0][0]);
    }
    //   int8[4][][] c9;      // int8[2][2][2]
    function testc9(int8[2][2][2] calldata x) external returns (int8[4] memory, int8[4] memory, int8[4] memory, int8[4] memory) {
        c9 = x;
        return (c9[1][1], c9[1][0], c9[0][1], c9[0][0]);
    }
    //   int8[3][4][3] c10;   // int8[2][2][2]
    function testc10(int8[2][2][2] calldata x) external returns (int8[3] memory, int8[3] memory, int8[3] memory, int8[3] memory) {
        c10 = x;
        return (c10[1][1], c10[1][0], c10[0][1], c10[0][0]);
    }
}