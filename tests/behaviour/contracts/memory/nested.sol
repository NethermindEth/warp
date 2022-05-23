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
}
