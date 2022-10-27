pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

function __warp_freeFunction() pure returns (uint8) {
  return 2;
}

contract WARP {
  function useFreeFunction() public pure returns (uint8) {
    return __warp_freeFunction();
  }
}
