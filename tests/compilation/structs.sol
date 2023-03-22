pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  struct StructType {
    uint256[] contents;
    uint256 moreInfo;
    uint8[] banter;
  }

  struct Banter {
    StructType s;
    StructType[] r;
  }
}
