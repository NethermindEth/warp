pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

library libA {
  function Add(uint8 x, uint8 y) pure external returns (uint8) {
    return x+y;
  }
}

library libB {
  function Subtract(uint8 x, uint8 y) pure external returns (uint8) {
    return x+y;
  }
}

function multiply(uint8 x, uint8 y) pure returns (uint8) {
  return x*y;
}

 struct Account {
   uint balance;
   uint dailylimit;
 }

 enum selectEnum{ SMALL, MEDIUM, LARGE }
   selectEnum constant defaultChoice = selectEnum.MEDIUM;



