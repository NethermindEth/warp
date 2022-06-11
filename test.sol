pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
  State Variables having miscellaneous types
*/

contract WARP {


  enum B{
    A1, A2, A3,
    B1, B2, B3,
    C1, C2, C3
  }
  B[] public g = [B.A1, B.A2, B.A3];
  
}
