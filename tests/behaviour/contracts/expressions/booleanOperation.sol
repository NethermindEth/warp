pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function false_and() pure public returns (bool) {
    return callNull() && true;  // null
  }

  function true_or() pure public returns (bool) {
    return callNull() || false;  // null
  }

  function callNull() pure public returns (bool) {
    return true && false;
  }
}
