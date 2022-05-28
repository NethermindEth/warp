// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {

mapping(int8 => uint[3]) map5;
  function staticArrayValue(uint8 x, uint y, uint8 z) external returns (uint, uint, uint) {
    map5[1] = [x, y, z];
    return (map5[1][0], map5[1][1], map5[1][2]);
  }
}

