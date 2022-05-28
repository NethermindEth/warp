pragma solidity ^0.8.11;

// SPDX-License-Identifier: MIT

contract WARP {
  mapping(uint8 => mapping(uint8 => uint8)) map1;
  mapping(uint8 => mapping(uint8 => uint8)) map2;

  function nestedMappings(uint8 x) public returns (uint8) {
    mapping(uint8 => uint8) storage localMap = map1[2];
    map1[2][1] = x;
    map2[2][1] = x + 1;
    return localMap[1];
  }

  mapping(uint => uint8) map3;
  function nonFeltKey(uint x, uint8 y) public returns (uint8) {
    map3[x] = y;
    map3[x + 1] = y + 1;
    return map3[x];
  }

  struct structDef {
      uint8 member1;
      uint member2;
  }
  mapping(int8 => structDef) map4;
  function structValue(uint8 x, uint y) external returns (uint8, uint) {
    map4[1] = structDef(x, y);
    return (map4[1].member1, map4[1].member2);
  }

  mapping(int8 => uint[3]) map5;
  function staticArrayValue(uint x, uint y, uint z) external returns (uint, uint, uint) {
    map5[1] = [x, y, z];

    return (map5[1][0], map5[1][1], map5[1][2]);
  }


  mapping(int8 => uint[]) map6;
  function dynamicArrayValue(uint x, uint y, uint z) external returns (uint, uint, uint) {
    map6[1] = new uint[](3);
    map6[1][0] = x;
    map6[1][1] = y;
    map6[1][2] = z;

    return (map6[1][0], map6[1][1], map6[1][2]);
  }
}
