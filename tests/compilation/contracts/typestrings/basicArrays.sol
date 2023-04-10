pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

contract WARP {
  bytes stateDynBytes;
  string stateString;
  bool[3] stateFixedArr;
  bool[3][4] stateFixedFixedArr;
  bool[][3] stateDynFixedArr;
  bool[3][] stateFixedDynArr;

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
  }
}
