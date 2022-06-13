pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT


contract WARP {
  
  mapping(string => uint8) map_su;
  mapping(string => string) map_ss;
  
  function cdString(string calldata s) public returns (uint8) {
    map_su[s] = 5;
    return map_su[s];
  }

  function memStringLiteral() public returns (uint8) {
    map_su["bb"] = 10;
    return map_su["bb"];
  }

  function memStringVariable() public returns (uint8) {
    string memory s = "abc";
    map_su[s] = 15;
    return map_su[s];
  }
  
  string str;
  function storageString() public returns (uint8) {
    str = "c";
    map_su[str] = 20;
    return map_su[str];
  }

  function emptySlot() public view returns (uint8) {
    return map_su["xxx"];
  }

  function nestedMapCalls() public returns (uint8) {
    map_ss["yz"] = "hello";
    map_su[map_ss["yz"]] = 25;
    return map_su["hello"];
  }
}