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
  InnerStruct[3] stateFixedStructArr;
  InnerStruct[3][4] stateFixedFixedStructArr;
  InnerStruct[][3] stateDynFixedStructArr;
  InnerStruct[3][] stateFixedDynStructArr;
  Struct[3] stateFixedNestedStructArr;
  Struct[3][4] stateFixedFixedNestedStructArr;
  Struct[][3] stateDynFixedNestedStructArr;
  Struct[3][] stateFixedDynNestedStructArr;

  function referenceTypes() external {
    InnerStruct[3] storage SlocalFixedStructArr = stateFixedStructArr;
    InnerStruct[3] memory MlocalFixedStructArr;
    InnerStruct[3][4] storage SlocalFixedFixedStructArr = stateFixedFixedStructArr;
    InnerStruct[3][4] memory MlocalFixedFixedStructArr;
    InnerStruct[][3] storage SlocalDynFixedStructArr = stateDynFixedStructArr;
    InnerStruct[][3] memory MlocalDynFixedStructArr;
    InnerStruct[3][] storage SlocalFixedDynStructArr = stateFixedDynStructArr;
    InnerStruct[3][] memory MlocalFixedDynStructArr;
    Struct[3] storage SlocalFixedNestedStructArr = stateFixedNestedStructArr;
    Struct[3] memory MlocalFixedNestedStructArr;
    Struct[3][4] storage SlocalFixedFixedNestedStructArr = stateFixedFixedNestedStructArr;
    Struct[3][4] memory MlocalFixedFixedNestedStructArr;
    Struct[][3] storage SlocalDynFixedNestedStructArr = stateDynFixedNestedStructArr;
    Struct[][3] memory MlocalDynFixedNestedStructArr;
    Struct[3][] storage SlocalFixedDynNestedStructArr = stateFixedDynNestedStructArr;
    Struct[3][] memory MlocalFixedDynNestedStructArr;

    stateFixedStructArr;
    SlocalFixedStructArr;
    MlocalFixedStructArr;

    stateFixedFixedStructArr;
    SlocalFixedFixedStructArr;
    MlocalFixedFixedStructArr;

    stateDynFixedStructArr;
    SlocalDynFixedStructArr;
    MlocalDynFixedStructArr;

    stateFixedDynStructArr;
    SlocalFixedDynStructArr;
    MlocalFixedDynStructArr;

    stateFixedNestedStructArr;
    SlocalFixedNestedStructArr;
    MlocalFixedNestedStructArr;

    stateFixedFixedNestedStructArr;
    SlocalFixedFixedNestedStructArr;
    MlocalFixedFixedNestedStructArr;

    stateDynFixedNestedStructArr;
    SlocalDynFixedNestedStructArr;
    MlocalDynFixedNestedStructArr;

    stateFixedDynNestedStructArr;
    SlocalFixedDynNestedStructArr;
    MlocalFixedDynNestedStructArr;
  }
}
