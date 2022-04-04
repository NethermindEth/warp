pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

import './mathLib1.sol';

library Multiplication {
  using Addition for uint8;
  
  function multiply(uint8 x, uint8 y) pure external returns (uint8) {
    uint8 product=0;
    for(uint i=0; i<y; i++){
      product = Addition.add(product, x);
    }
    return product;
  }
}

library Division {
  using Addition for uint8;
  using Subtraction for uint8;

  function divide(uint8 x, uint8 y) pure external returns (uint8, uint8) {
    uint8 remainder=x;
    uint8 quotient=0;
    while(x>y){
      x = Subtraction.subtract(x, y);
      quotient = Addition.add(quotient,1);
      remainder = x ;
    }
    return(quotient, remainder);
  }
}