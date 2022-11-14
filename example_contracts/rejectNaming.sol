pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

function __warp_freeFunction() pure returns (uint8) {
  return 2;
}

contract WARP {
  struct __warp_A {
    int256 a;
    mapping(address => address) __warp_b;
  }
  __warp_A public __warp_b;
  __warp_A private c;

  event __warp_Log0(address _from, uint256 _id);

  function __warp_useFreeFunction(uint256 __warp_id) public returns (uint8) {
    emit __warp_Log0(msg.sender, __warp_id);
    return __warp_freeFunction();
  }
}
