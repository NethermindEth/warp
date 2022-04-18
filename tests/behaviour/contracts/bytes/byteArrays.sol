// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract WARP {

  bytes2[3] ba;
  bytes2[] d;
  uint constant bbb = 2;

  constructor() {
    ba[0] = 0x1234;
    ba[1] = 0x2345;
    ba[2] = 0x3456;
  }

  function getC(uint8 i) public view returns (bytes2) {
    return ba[i];
  }

  function getStorageBytesArray() external view returns (bytes2) {
    return ba[2];
  }

  function getMemoryBytesArray() public pure returns (bytes2) {
    bytes2[bbb] memory abc;
    abc[0] = 0x1234;
    abc[1] = 0x2345;
    return abc[1];
  }

  function getStorageBytesDynArray() external returns (bytes2) {
    d.push(0x1234);
    return d[0];
  }
}
