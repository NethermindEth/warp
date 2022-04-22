// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract WARP {
  struct bytes33 {
    bytes2 a;
    bytes16 b;
    byte c;
  }

  struct byteStruct {
    bytes2 a;
    bytes16 b;
    byte c;
  }

  bytes33 b3;
  byteStruct bs;

  constructor() {
    b3 = bytes33({
      a: 0x1234,
      b: 0x12341234123412341234123412341234,
      c: 0x12
    });

    bs = byteStruct({
      a: 0x1234,
      b: 0x12341234123412341234123412341234,
      c: 0x12
    });
  }

  function getB3A() public view returns (bytes2) {
    return b3.a;
  }

  function getBsC() public view returns (byte) {
    return bs.c;
  }
}
