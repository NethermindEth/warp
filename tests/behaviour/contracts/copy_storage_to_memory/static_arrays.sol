pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[5] x = [1, 2, 3, 4, 5];
  uint8[15] y;


  // Throw errors if they are not explicitly cast
  uint256[3] w = [uint256(1), uint256(2), uint256(3)];
  uint256[6] z = [uint256(1), uint256(2), uint256(3), uint256(4), uint256(5), uint256(6)];

  constructor() {
      y[0] = 5;
      y[5] = 10;
      y[10] = 15;
      y[14] = 17;
  }

  function getX()  public view returns (uint8[5] memory) {
    uint8[5] memory xx = x;
    return xx;
  }

  function getY() public view returns (uint8[15] memory) {
    uint8[15] memory yy = y;
    return yy;
  }

  function getW() public view returns (uint256[3] memory) {
    uint256[3] memory ww = w;
    return ww;
  }

  function getZ() public view returns (uint256[6] memory) {
    uint256[6] memory zz = z;
    return zz;
  }
}


