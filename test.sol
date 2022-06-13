pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT


contract WARP {
  
  mapping(string => uint8) map;
  
  // function cdString(string calldata s) public returns (uint8) {
  //   map[s] = 5;
  //   return map[s];
  // }

  // function memStringLiteral() public returns (uint8) {
  //   map["b"] = 10;
  //   return map["b"];
  // }

  function memStringVariable() public {
    map['ab'];
  }
  
  // string str;
  // function storageString() public returns (uint8) {
  //   str = "c";
  //   map[str] = 15;
  //   return map[str];
  // }

  // function emptySlot() public view returns (uint8) {
  //   return map["xxx"];
  // }
}