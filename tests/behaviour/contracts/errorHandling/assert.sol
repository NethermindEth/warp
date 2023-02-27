pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function shouldFail(bool a) pure public {
    uint8 x = 1;
    if (a) {
      assert(x == 2);
    }
    assert(x == 21 );
  }

  function willPass() pure public {
    uint8 x = 2;
    return assert(x == 2);
  }
}
