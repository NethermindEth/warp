pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

struct S {
  uint a;
  T t;
}

struct T {
  uint a;
}

contract WARP {
    S s;
    T t;

    function copySimpleStruct(uint a) public {
      T memory tMem = T(a);
      t = tMem;
    }

    function copyNestedStruct(uint a, uint b) public {
      S memory sMem = S(a, T(b));
      s = sMem;
    }

    function copyInnerStruct(uint a) public {
      T memory tMem = T(a);
      s.t = tMem;
    }

    // Results are unpacked because this test is not to test for return structs
    function getStructs() view public returns (uint, uint, uint) {
      return (s.a, s.t.a, t.a);
    }
}
