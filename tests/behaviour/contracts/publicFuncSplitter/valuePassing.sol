pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT
struct s1 {
  uint8 x;
  uint8 y;
}

contract A {

  function modifyStructCrossContract(s1 memory memoryStruct) pure public returns (uint8) {
    memoryStruct.x = 10;
    memoryStruct.y = 11;
  }

}

contract WARP {

  function modifyMemoryStruct(s1 memory memoryStruct) pure public {
    memoryStruct.x = 10;
    memoryStruct.y = 11;
  }

  function testExternalCallMemberAccess() view external returns (s1 memory) {
    s1 memory originalStruct = s1(1, 2);
    this.modifyMemoryStruct(originalStruct);
    return originalStruct;
  }

  function testInternalCallMemberAccess() pure external returns (s1 memory) {
    s1 memory originalStruct = s1(1, 2);
    WARP.modifyMemoryStruct(originalStruct);
    return originalStruct;
  }

  function testInternalCallIdentifier() pure external returns (s1 memory) {
    s1 memory originalStruct = s1(1, 2);
    modifyMemoryStruct(originalStruct);
    return originalStruct;
  }

    function testExternalCallCrossContract(address addr) pure public returns (s1 memory) {
    A a = A(addr);
    s1 memory originalStruct = s1(1, 2);
    a.modifyStructCrossContract(originalStruct);
    return originalStruct;
  }
}
