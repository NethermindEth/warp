pragma solidity ^0.8.10;

// SDPX-License-Identifer: MIT

contract WARP {
  function compoundAssignmentToMemory() pure public returns (uint8[2] memory) {
    /// uint8[2] memory memArr = [1,2];
    uint8[2] memory memArr = [1,2];
    /// uint i = 1;
    uint i = 0;
    /// memArr[i++] = 3;
    memArr[i++] += 2;
    assert(i == 1);
    /// memArr[i++] = 4;
    memArr[i++] += 2;
    assert(i == 2);
    /// return memArr;
    return memArr;
  }

  uint8[2] storageArr;
  function compoundAssignmentToStorage() public returns (uint8[2] memory) {
    /// storageArr = [1,2];
    storageArr = [1,2];
    /// uint i = 1;
    uint i = 0;
    /// storageArr[i++] = 3;
    storageArr[i++] += 2;
    /// storageArr[i++] = 4;
    storageArr[i++] += 2;
    /// return storageArr;
    return storageArr;
  }
}
