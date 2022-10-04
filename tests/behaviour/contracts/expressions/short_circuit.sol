pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function and_sc() pure public returns (uint) {
    uint a = 56;
    if (a == 4 && (a=1) == 6){
        return a;
    }
    return a; // 56
  }
  function and_no_sc() pure public returns (uint) {
    uint a = 56;
    if (a == 56 && (a=1) == 6){
        a = 9;
    }
    return a; // 1
  }
  function or_sc() pure public returns (uint) {
    uint a = 56;
    if (a == 56 || (a=1) == 6){
        uint b = 8;
    }
    return a; // 56
  }
  function or_no_sc() pure public returns (uint) {
    uint a = 56;
    if (a == 4 || (a=15) == 6){
        uint b = 20;
    }
    return a; // 15
  }
}
