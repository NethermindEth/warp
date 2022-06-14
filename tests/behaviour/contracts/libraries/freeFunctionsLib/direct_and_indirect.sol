pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

library Add {
  function add(uint8 x, uint8 y) external returns (uint8) {
    return freeFunc_add(x, y);
  }
}

library Subtract {
    function sub(uint8 x) pure external returns (uint8) {
        return x-1;
    }
}

function freeFunc_add(uint8 x, uint8 y) returns (uint8) {
  return x + Subtract.sub(y);
}

function freeFunc_indirect(uint8 x) returns (uint8){
  return Add.add(x, x) ;
}

function freeFunc_direct(uint8 x) returns (uint8) {
  uint8 y = Subtract.sub(x) + freeFunc_indirect(x);
  return y;
}

contract WARP {
  function freeFuncLib(uint8 x) public returns (uint8) {
    uint8 y = freeFunc_direct(x);
    return y;
  }
}
