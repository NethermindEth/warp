pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[] x;

  function getArray() public view returns (uint8[] memory) {
    return x;
  }

}
