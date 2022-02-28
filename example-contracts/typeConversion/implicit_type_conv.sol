pragma solidity ^0.8.6;
// SPDX-License-Identifier: MIT

contract WARP {
  function callFunction(
    uint8 src,
    uint16 dst,
    uint24 wad,
    uint256 sender
  ) public view returns (uint256) {
    uint32 f = src + uint8(dst);
    uint248 y = f + wad;
    return sender + y;
  }

}
