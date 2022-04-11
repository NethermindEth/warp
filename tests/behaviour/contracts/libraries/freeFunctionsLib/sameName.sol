pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT


library test {
  function freeFuncLib(bool x) pure external returns (bool) {
    return x;
  } 
} 

function freeFuncLib(bool x) pure returns (bool){
  return !test.freeFuncLib(x);
}

function freeFunction(bool x) pure returns (bool) {
  return freeFuncLib(x);
}

contract WARP {
  function freeFuncLib(bool x) pure public returns (bool) {
    return freeFunction(x);
  }
}