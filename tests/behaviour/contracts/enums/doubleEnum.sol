pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

enum TopEnum { uu, vv, xx, yy, zz }

contract WARP {
  enum Enum { a, b, c }
  Enum public _a = Enum.c;
  TopEnum bp;

  function a() public view returns (Enum) {
    return _a;
  }

  function getTopEnum() public view returns (TopEnum) {
    return bp;
  }

  function setB() public {
    if (_a == Enum.b) {
      bp = TopEnum.vv;
      _a = Enum.a;
    } else {
      _a = Enum.b;
      bp = TopEnum.zz;
    }
  }
}
