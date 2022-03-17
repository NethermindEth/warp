pragma solidity ^0.8.11;

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
}
