pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

struct T {
  uint256 b;
}

struct S {
  bool b;
  T t;
  uint256 u;
}

contract WARP {
  S s1;
  S s2;

  function setStruct1(bool sb, uint256 tb, uint256 su) external {
    s1.b = sb;
    s1.t.b = tb;
    s1.u = su;
  }

  function copyFull() external {
    s2 = s1;
  }

  function copyInner() external {
    s2.t = s1.t;
  }

  function getStruct1() external returns (bool, uint256, uint256) {
    return (s1.b, s1.t.b, s1.u);
  }

  function getStruct2() external returns (bool, uint256, uint256) {
    return (s2.b, s2.t.b, s2.u);
  }
}
