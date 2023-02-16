pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function shouldFail() pure public {
    uint8 x = 1;
    return require(x == 2, "why is x not 2???");
  }

  function willPass() pure public {
    return require(true, "hah");
  }
}
