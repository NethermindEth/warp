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
}
