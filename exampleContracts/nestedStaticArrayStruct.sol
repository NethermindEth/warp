pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  struct N {
      uint8 id;
  }

  N[3] rare;
  N[6] common;

  constructor() {
      rare[0] = N(0);
      rare[1] = N(1);
      rare[2] = N(2);

      common[0] = N(0);
      common[1] = N(1);
      common[2] = N(2);
      common[3] = N(3);
      common[4] = N(4);
      common[5] = N(5);
  }

  function getRare()  public view returns (N[3] memory) {
    N[3] memory rr = rare;
    return rr;
  }

  function getCommon() public view returns (N[6] memory) {
    N[6] memory cc = common;
    return cc;
  }
}
