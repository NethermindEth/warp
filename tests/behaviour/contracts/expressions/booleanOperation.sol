pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function false_and() pure public returns (bool) {
    return callNull();  // null at compile time
  }

  function true_or() pure public returns (bool) {
    return callNull();  // null at compile time
  }

  function callNull() pure public returns (bool) {
    return true && false;
  }
}