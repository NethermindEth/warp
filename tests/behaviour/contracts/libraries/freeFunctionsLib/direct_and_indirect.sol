pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT


library Add {
  function add(uint8 x) pure external returns (uint8) {
    return x+2;
  } 
} 

library Subtract {
    function sub(uint8 x) pure external returns (uint8) {
        return x-1;
    }
}

function freeFunc_indirect(uint8 x) pure returns (uint8){
  return Add.add(x) ;
}

function freeFunc_direct(uint8 x) pure returns (uint8) {
  uint8 y = Subtract.sub(x) + freeFunc_indirect(x);
  return y;
}

contract WARP {
  function freeFuncLib(uint8 x) pure public returns (uint8) {
    uint8 y = freeFunc_direct(x);
    return y;
  }
}
