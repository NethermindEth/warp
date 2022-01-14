pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function shouldFail() pure public {
    uint x = 1;
    require(x == 2);
  }
}
