pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for libraries and free functions
 import {lib, multiply } from './importfrom.sol';

contract WARP{
    using lib for uint8;

    function checkImports(uint8 num1, uint8 num2) pure public returns (bool) {
    uint8 m = multiply(num1, num2);
    uint8 product=0;
    for(uint i=0; i<num2; i++){
      product = lib.Add(product, num1);
    }
    return (m == product);
  }

}
