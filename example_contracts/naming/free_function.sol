pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

function freeFunction() pure returns (uint8) {
  return 2;
}

contract WARP {
  function __warp_useFreeFunction() public pure returns (uint8) {
    return freeFunction();
  }
}
