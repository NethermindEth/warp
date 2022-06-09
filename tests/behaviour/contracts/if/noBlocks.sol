pragma solidity ^0.8.14;

// SDPX-License-Identifier: MIT

contract WARP {
  function test(bool choice1, bool choice2) pure public returns (uint8) {
    if (choice1)
      if (choice2)
        return 3;
      else return 2;
    else if (choice2) return 1; else return 0;
  }
}
