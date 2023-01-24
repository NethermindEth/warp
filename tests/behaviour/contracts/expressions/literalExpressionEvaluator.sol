pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function false_and() pure public returns (bool) {
    return true && false;  // false 
  }

  function true_or() pure public returns (bool) {
    return false || true;  // true 
  }
}