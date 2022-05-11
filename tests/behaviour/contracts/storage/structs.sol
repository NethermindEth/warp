pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

  struct S {
    uint a;
  }
contract WARP {


  S s;
  uint b;

  function getMember() view public returns (uint) {
    return s.a;
  }

  function setMember(uint a) public {
    b = a;
    a = b;
    s.a = a;
  }

  function assign(uint a) public {
    s = S(a);
  }
}
