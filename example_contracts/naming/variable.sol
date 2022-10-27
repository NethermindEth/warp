pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  struct A {
    int256 __warp_a;
    mapping(address => address) b;
  }
  A public b;
  A private c;
}
