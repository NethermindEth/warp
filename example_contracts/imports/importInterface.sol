pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for enum
import { Calculator } from './importfrom.sol';

contract WARP is Calculator{
  constructor() public {}
   function getResult() external override view returns(uint){
      uint a = 1; 
      uint b = 2;
      uint result = a + b;
      return result;
   }
}
