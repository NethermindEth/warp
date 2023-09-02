pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[] x;

  function returnStorageArray() public view returns (uint8[] memory) {
    return x;
  }

  function returnMemoryArray(uint128[] memory) public view returns (uint128[] memory) {
    uint128[] memory y = new uint128[](10);
    return y;
  }
}
