pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
    function inAndOut(uint[2][2][] calldata y) pure external returns (uint[2][2][] memory) {
      uint [2][2][] memory m = y;
      return m;
    }

    function inAndOutLength(uint[2][2][] calldata y) pure external returns (uint, uint) {
      uint [2][2][] memory m = y;
      return (y.length, m.length);
    }
}
