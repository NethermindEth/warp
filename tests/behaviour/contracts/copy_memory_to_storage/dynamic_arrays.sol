pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  uint8[] public arr8 = new uint8[](5);
  uint[] public arr256 = new uint[](10);
  uint16[] public arr16 = [1, 2, 3, 4];

  function getLengths() view public returns (uint, uint) {
    return (arr8.length, arr256.length);
  }

  function assign8(uint length) public {
    arr8 = new uint8[](length);
  }

  function assign256(uint length) public {
    arr256 = new uint[](length);
  }

  function fillWithValues() public {
    for(uint8 i = 0; i < arr8.length; ++i) {
      arr8[i] = i + 1;
    }

    uint shift = 2 ** 128;

    for(uint i = 0; i < arr256.length; ++i) {
      arr256[i] = i + 1 + shift * (i + 2);
    }
  }

  function assignToTupleArray() public returns(uint16) {
    arr16[3] = 10;
    return arr16[3];
  }
}
