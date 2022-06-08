pragma solidity ^0.8.10;

// SDPX-License-Identifier: MIT

contract WARP {
  function bytes1To2(bytes1 b) pure public returns (bytes2) {
    return b;
  }

  function bytes3To3(bytes3 b) pure public returns (bytes3) {
    return bytes3(b);
  }

  function bytes4To32(bytes4 b) pure public returns (bytes32) {
    return b;
  }
}
