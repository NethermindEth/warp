pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  // need to check small dim to larger size.
  // need to check small nBits to larger nBits
  // Static to Dynamic

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