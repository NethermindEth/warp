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

  function bytes8To4(bytes8 b) pure public returns (bytes4) {
    return bytes4(b);
  }

  function bytes32To16(bytes32 b) pure public returns (bytes16) {
    return bytes16(b);
  }

  function bytes32To1(bytes32 b) pure public returns (bytes1) {
    return bytes1(b);
  }
  
  function bytes25To7(bytes25 b) pure public returns (bytes7) {
    return bytes7(b);
  }

  function bytes4To2Assignment() pure public returns (bytes2) {
    bytes4 b4 = hex"12345678";
    bytes2 b2 = bytes2(b4);
    return b2;
  }
}
