pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT


contract WARP {
  
  mapping(bytes => uint8) map_bu;
  mapping(bytes => bytes) map_bb;
  
  function cdBytes(bytes calldata s) public returns (uint8) {
    map_bu[s] = 5;
    return map_bu[s];
  }

  function memBytesLiteral() public returns (uint8) {
    map_bu["bb"] = 10;
    return map_bu["bb"];
  }

  function memBytesVariable() public returns (uint8) {
    bytes memory s = "abc";
    map_bu[s] = 15;
    return map_bu[s];
  }
  
  bytes by;
  function storageBytes() public returns (uint8) {
    by = "c";
    map_bu[by] = 20;
    return map_bu[by];
  }

  function emptySlot() public view returns (uint8) {
    return map_bu["xxx"];
  }

  function nestedMapCalls() public returns (uint8) {
    map_bb["yz"] = "hello";
    map_bu[map_bb["yz"]] = 25;
    return map_bu["hello"];
  }

  function sameBytesKey() public returns (bool) {
    bytes memory s1 = "hi";
    bytes memory s2 = "hi";
    map_bu[s1] = 30;
    return map_bu[s2] == map_bu[s1];
  }

  function bytesValueChange() public returns (bool) {
    bytes memory s1 = "yo";
    map_bu[s1] = 35;
    s1 = "lol";
    return map_bu[s1] != map_bu["yo"];
  }
}