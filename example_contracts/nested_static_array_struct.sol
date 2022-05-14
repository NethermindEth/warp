pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  struct N {
      uint8 id;
      uint8[3] prop;
      uint8[6] attr;
  }

  N[3] rare;
  N[6] common;

  constructor() {
      rare[0] = N(0, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      rare[1] = N(1, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      rare[2] = N(2, [1, 2, 3], [1, 2, 3, 4, 5, 6]);

      common[0] = N(0, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      common[1] = N(1, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      common[2] = N(2, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      common[3] = N(3, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      common[4] = N(4, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
      common[5] = N(5, [1, 2, 3], [1, 2, 3, 4, 5, 6]);
  }

  function getRare()  public view returns (N[3] memory) {
    return rare;
  }

  function getCommon() public view returns (N[6] memory) {
      return common;
  }
}
