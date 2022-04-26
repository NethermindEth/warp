pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  struct S{
    mapping(uint8 => uint8) map;
  }
  S[] x;

  struct StructDef2 {
    uint8 y;
  }
  struct StructDef {
    uint8 x; 
    uint8 y;
    StructDef2 z;
  }

  function test() pure internal returns (uint8) {
    StructDef[] memory struct_array = new StructDef[](3);
    struct_array[0] = StructDef(1,2,StructDef2(1));
    return struct_array[1].x;
  }

  // function nesting() public returns (uint8) {
  //   x.push();
  //   x[0].map[4] = 5;
  //   mapping(uint8 => uint8) storage map = x[0].map;
  //   x.pop();
  //   return map[4];
  // }
}
