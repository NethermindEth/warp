pragma solidity ^0.8.11;
//SPDX-License-Identifier: MIT

contract WARP {
  struct S {
      uint8[6] m4;
  }
  S s;

  function setS()  public {
    s = S([1, 2, 3, 4, 5, 6]);
  }

  function getS() public view returns (S memory) {
    S memory ss  = s;
    return ss;
  }
}
