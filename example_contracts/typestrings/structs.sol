pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

struct InnerStruct {
  uint intMember;
}
struct Struct {
  uint intMember;
  InnerStruct innerStruct;
}

contract WARP {
  InnerStruct stateStruct;
  Struct stateNestedStruct;

  function referenceTypes() external {
    InnerStruct storage SlocalStruct = stateStruct;
    InnerStruct memory MlocalStruct;
    Struct storage SlocalNestedStruct = stateNestedStruct;
    Struct memory MlocalNestedStruct;

    stateStruct;
    SlocalStruct;
    MlocalStruct;

    stateNestedStruct;
    SlocalNestedStruct;
    MlocalNestedStruct;
  }
}