// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract WARP {
  function f() public pure returns (uint8[2] memory) {
    uint8[2] memory x;
    uint8[2] memory y;
    (x, y) = ([9, 12], [10, 33]);
    return x;
  }

  function g() public pure returns (uint8) {
    uint8[2] memory arr = f();
    return (arr[0] + arr[1]);
  }
}
