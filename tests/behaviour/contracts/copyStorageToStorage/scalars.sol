pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {

  uint wide;
  uint8 narrow;

  function getValues() view external returns (uint8, uint) {
    return (narrow, wide);
  }

  function set256(uint a) external {
    wide = a;
  }

  function set8(uint8 a) external {
    narrow = a;
  }

  function copy8To256() external {
    wide = narrow;
  }

  function copy256To8() external {
    narrow = uint8(wide);
  }
}
