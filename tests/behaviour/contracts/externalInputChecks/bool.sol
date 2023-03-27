pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

  bool stateBoolVariable1;
  bool stateBoolVariable2;

  function externalFunction(bool x) external returns (bool){
    stateBoolVariable1 = x;
    return stateBoolVariable1;
  }
  
  function externalFunction2Inputs(bool x, bool y) external returns (bool){
    stateBoolVariable1 = x;
    stateBoolVariable2 = x;
    return y;
  }
  
}

