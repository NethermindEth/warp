pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

contract WARP {
  uint16[4] arr1;
  uint16[4] arr2;

  function setArr1(uint16 a, uint16 b, uint16 c, uint16 d) external {
    arr1[0] = a;
    arr1[1] = b;
    arr1[2] = c;
    arr1[3] = d;
  }

  function copy() external {
    arr2 = arr1;
  }

  function getArr1() view external returns (uint16, uint16, uint16, uint16) {
    return (arr1[0], arr1[1], arr1[2], arr1[3]);
  }

  function getArr2() view external returns (uint16, uint16, uint16, uint16) {
    return (arr2[0], arr2[1], arr2[2], arr2[3]);
  }
}
