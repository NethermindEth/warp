// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;

contract WARP {
  function f(
    uint256 x,
    uint8 y,
    uint8 z
  ) internal pure returns (bytes memory) {
    return abi.encode(x, y, z);
  }
}
