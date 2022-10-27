pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  struct A {
    int256 a;
    mapping(address => address) b;
  }
  A public __warp_b;
  A private c;
}
