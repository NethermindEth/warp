pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  struct S {
      uint256 m1;
      uint32 m2;
      uint32 m3;
  }
  S s;

  struct P {
     uint8[] d1;
  }
  P p;

  function setS(uint256 m1, uint32 m2, uint32 m3)  public {
    s = S(m1, m2, m3);
  }

  function getS() public view returns (S memory) {
    S memory ss  = s;
    return ss;
  }

  function setP(uint8[] memory d1) public  {
      p = P(d1);
  }

  function getP() public view returns (uint8[] memory) {
      P memory pp = p;
      return pp.d1;
  }
}
