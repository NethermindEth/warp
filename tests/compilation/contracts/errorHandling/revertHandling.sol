pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function definitelyFailsWithMsg() pure public {
      return revert("I am failing");
  }

  function couldFail(uint8 a) pure public returns (uint8) {
    if (a == 1) {
      revert("I am failing");
    } else {
      return 4;
    }
  }
}
