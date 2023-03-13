pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function addingLocalAssignments(uint8 a, uint8 b) pure public returns (uint8) {
    uint8 x;
    return (x = a) + (x = b);
  }

  uint8 y;
  function addingStorageAssignments(uint8 a, uint8 b) public returns (uint){
    return (y = a) + (y = b);
  }

  mapping(uint8 => uint8) m1;
  mapping(uint8 => uint8) m2;
  function assigningLocalStoragePointers() public returns (uint8, uint8, uint8, uint8) {
    mapping(uint8 => uint8) storage m = m1;
    m[1] = 42;

    (m = m2)[2] = 21;

    return (m1[1], m1[2], m2[1], m2[2]);
  }
}
