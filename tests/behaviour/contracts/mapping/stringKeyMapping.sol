pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT


contract WARP {
  
  mapping(string => uint8) map;
  
  // function cdString(string calldata s) public returns (uint8) {
  //   map[s] = 5;
  //   return map[s];
  // }

  function memStringLiteral() public returns (uint8) {
    map["bb"] = 10;
    return map["bb"];
  }

  // function memStringVariable() public returns (uint8) {
  //   string memory s = "abc";
  //   map[s] = 15;
  //   return map[s];
  // }
  
  // string str;
  // function storageString() public returns (uint8) {
  //   str = "c";
  //   map[str] = 20;
  //   return map[str];
  // }

  // function emptySlot() public view returns (uint8) {
  //   return map["xxx"];
  // }
}