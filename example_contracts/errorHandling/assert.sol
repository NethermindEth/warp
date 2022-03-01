pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function shouldFail() pure public {
    int x = 1;
    assert(x == 2);
  }
}
