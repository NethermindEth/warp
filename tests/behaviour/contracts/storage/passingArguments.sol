pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[5] x;
  mapping(uint8 => uint8) shallowMap;

  function passArray() public returns (uint8) {
    useArray(x);
    return (x[3]);
  }

  function useArray(uint8[5] storage gh) internal {
    gh[3] = 4;
  }

  uint8 i;
  function passInt() public returns (uint8, uint8) {
    useInt(x[2]);
    useInt(i);
    return (x[2], i);
  }

  function useInt(uint8 a) internal {
    a = 5;
  }

  function passMap() public returns (uint8) {
    useMap(shallowMap);
    return shallowMap[10];
  }

  function useMap(mapping(uint8 => uint8) storage map) internal {
    map[10] = 20;
  }

  struct S {
    uint8 s;
  }
  S s;
  function passStruct() public returns (uint8) {
    useStruct(s);
    return s.s;
  }

  function useStruct(S storage str) internal {
    str.s = 5;
  }
}
