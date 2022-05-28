pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  enum enumSet1{ENUM_VALUE_1, ENUM_VALUE_2, ENUM_VALUE_3}
  enum enumSet2{ENUM_VALUE_1, ENUM_VALUE_2, ENUM_VALUE_3, ENUM_VALUE_4}
  
  enumSet1 currentEnumValue1;
  enumSet2 currentEnumValue2;

  function externalFunction(enumSet1 enumInput) external returns (enumSet1) {
    currentEnumValue1 = enumInput;
    return currentEnumValue1;
  }
  
  // function externalFunction2Inputs(enumSet1 enumInput1, enumSet2 enumInput2) external returns (uint8){
  //   currentEnumValue1 = enumInput1;
  //   currentEnumValue2 = enumInput2;
  //   return 1;
  // }

}

