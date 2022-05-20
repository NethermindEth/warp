pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

enum Bird {
  A
}

contract WARP {
  Bird[3] stateFixedArr;
  uint256[3] stateFixedIntArr;
  mapping(Bird => string) stateMap;

  function arrays() external view {
    Bird[3] memory MlocalEnumArr;
    Bird[3] storage SlocalEnumArr = stateFixedArr;
    uint256[3] memory MlocalIntArr;
    uint256[3] storage SlocalIntArr = stateFixedIntArr;
    Bird myEnum;

    MlocalEnumArr;
    SlocalEnumArr;

    MlocalIntArr;
    SlocalIntArr;

    myEnum;
    stateMap;

    second(MlocalEnumArr);

    Bird B = Bird.A;
  }

  function second(Bird[3] memory param) internal pure {
    param;
  }
}
