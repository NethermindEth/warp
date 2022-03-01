pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function couldFail(uint a) pure public returns (uint) {
    if (a == 1) {
      revert();
    } else {
      return 3;
    }
  }
}
