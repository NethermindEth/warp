pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

function freeFunction() pure returns (uint8) {
  return 2;
}

contract WARP {
  function useFreeFunction() pure public returns (uint8) {
    return freeFunction();
  }
}
