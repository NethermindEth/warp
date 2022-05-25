pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  struct S {
    uint start;
    T t;
    uint end;
  }

  struct T {
    uint8 a;
  }

  function setAndGet(uint8 a) pure public returns (uint8) {
    S memory s = S(0,T(a),0);
    return s.t.a;
  }

  function memberAssign(uint a, uint8 b, uint c, uint d, uint8 e, uint f) pure public returns (uint, uint8, uint) {
    S[3] memory a1;
    S[3] memory a2;

    a1[1] = S(a,T(b),c);
    ///assignment
    a2[1] = a1[1];
    a1[1] = S(d,T(e),f);
    return (a2[1].start, a2[1].t.a, a2[1].end);
  }

  function identifierAssign(uint a, uint8 b, uint c, uint d, uint8 e, uint f) pure public returns (uint, uint8, uint) {
    S[3][4] memory a1;
    S[3] memory a2;

    a1[2][1] = S(a,T(b),c);
    ///assignment
    a2 = a1[2];
    a1[2][1] = S(d,T(e),f);
    return (a2[1].start, a2[1].t.a, a2[1].end);
  }
}
