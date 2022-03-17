pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  enum enumSet{ENUM_VALUE_1, ENUM_VALUE_2, ENUM_VALUE_3}
  enumSet currentEnumValue;

  function externalFunction(enumSet enumInput) public returns (enumSet) {
    currentEnumValue = enumInput;
    return currentEnumValue;
  }
  
}

