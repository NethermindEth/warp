pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

  bool stateBoolVariable;

  function externalFunction(bool x) public returns (bool){
    stateBoolVariable = x;
    return stateBoolVariable;
  }
  
}

