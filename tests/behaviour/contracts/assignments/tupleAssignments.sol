pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

contract WARP {
  uint public x = 17;
  function gapAndOrder() public returns (uint a, uint b, uint c) {
    uint256[3] memory m;
    (m[0], m[1], , m[2], m[0]) = (1, x, 3, 4, 42);
    return (m[2], m[1], m[0]);
  }
}
