pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

contract Other {
}
enum Enum {
  A
}
struct InnerStruct {
  uint intMember;
}
struct Struct {
  uint intMember;
  InnerStruct innerStruct;
}

type udvt is uint16;

contract WARP {
  bool stateBool;
  int stateInt;
  address stateAddress;
  address payable stateAddressPayable;
  Other stateContract;
  bytes8 stateFixedBytes;
  bytes stateDynBytes;
  string stateString;
  Enum stateEnum;
  udvt stateUdvt;
  bool[3] stateFixedArr;
  bool[3][4] stateFixedFixedArr;
  bool[][3] stateDynFixedArr;
  bool[3][] stateFixedDynArr;
  InnerStruct stateStruct;
  Struct stateNestedStruct;
  InnerStruct[3] stateFixedStructArr;
  InnerStruct[3][4] stateFixedFixedStructArr;
  InnerStruct[][3] stateDynFixedStructArr;
  InnerStruct[3][] stateFixedDynStructArr;
  Struct[3] stateFixedNestedStructArr;
  Struct[3][4] stateFixedFixedNestedStructArr;
  Struct[][3] stateDynFixedNestedStructArr;
  Struct[3][] stateFixedDynNestedStructArr;

  function scalars() external {
    bool localBool;
    int localInt;
    address localAddress;
    address payable localAddressPayable;
    bytes7 localFixedBytes;
    Enum localEnum;
    udvt localUdvt;

    stateBool;
    localBool;

    stateInt;
    localInt;

    stateAddress;
    localAddress;

    stateAddressPayable;
    localAddressPayable;

    stateContract;
    Other localContract;
    localContract;

    stateFixedBytes;
    localFixedBytes;

    stateEnum;
    localEnum;

    stateUdvt;
    localUdvt;
  }

  function referenceTypes() external {
    bytes storage SlocalDynBytes = stateDynBytes;
    bytes memory MlocalDynBytes;
    string storage SlocalString = stateString;
    string memory MlocalString;
    bool[3] storage SlocalFixedArr = stateFixedArr;
    bool[3] memory MlocalFixedArr;
    bool[3][4] storage SlocalFixedFixedArr = stateFixedFixedArr;
    bool[3][4] memory MlocalFixedFixedArr;
    bool[][3] storage SlocalDynFixedArr = stateDynFixedArr;
    bool[][3] memory MlocalDynFixedArr;
    bool[3][] storage SlocalFixedDynArr = stateFixedDynArr;
    bool[3][] memory MlocalFixedDynArr;
    InnerStruct storage SlocalStruct = stateStruct;
    InnerStruct memory MlocalStruct;
    Struct storage SlocalNestedStruct = stateNestedStruct;
    Struct memory MlocalNestedStruct;
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

    stateDynBytes;
    SlocalDynBytes;
    MlocalDynBytes;

    stateString;
    SlocalString;
    MlocalString;

    stateFixedArr;
    SlocalFixedArr;
    MlocalFixedArr;

    stateFixedFixedArr;
    SlocalFixedFixedArr;
    MlocalFixedFixedArr;

    stateDynFixedArr;
    SlocalDynFixedArr;
    MlocalDynFixedArr;

    stateFixedDynArr;
    SlocalFixedDynArr;
    MlocalFixedDynArr;

    stateStruct;
    SlocalStruct;
    MlocalStruct;

    stateNestedStruct;
    SlocalNestedStruct;
    MlocalNestedStruct;

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