pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
  State Variables having miscellaneous types
*/

contract WARP {

  // User Defined Types

  struct A {
    int256 a;
    mapping(address => address) b;
  }

  enum B{
    A1, A2, A3,
    B1, B2, B3,
    C1, C2, C3
  }

  struct C {
    int256 a;
    mapping(address => A) b;
    A[] c;
    B d;
  }

  struct D{
      uint256 a;
      address b;
  }

  struct E{
      address a;
      B b;
      D c;
  }

  struct F{
      address a;
      B b;
      C[] c;
  }

  struct G{
      address a;
      B b;
      C c;
  }

  type H is int32;
  type I is bytes11;

  // state variables

  uint256 a = 4;
  A public b;
  A private c;

  E public d = E(
    address(0x0000000000000000000000000000000000000001),
    B.A1,
    D(1, address(0x0000000000000000000000000000000000000001))
  );

  F public e;
  G private f;



  // Arrays

  B[] public g = [B.A1, B.A2, B.A3];
  E[][] public h ;
  G[] private i;
  H[][][][][] public j;

  // Mappings

  mapping(address => mapping(uint256 => address)) public k;
  mapping(address => A) public l;
  mapping(address => A[]) public m;
  mapping(address => mapping(address => mapping(B => uint))) public n;
  mapping(H => mapping(I => mapping(H => mapping(I => H[])))) public o;

  // Misc
  mapping(int => uint)[] public p;
  mapping(address => A[])[][] public q;
}
