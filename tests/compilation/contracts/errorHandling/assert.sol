pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function shouldFail() pure public {
    uint8 x = 1;
    return assert(x == 2 );
  }

  function willPass() pure public {
    uint8 x = 2;
    return assert(x == 2);
  }
}
