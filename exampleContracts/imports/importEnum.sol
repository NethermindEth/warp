pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for enum
import { selectEnum } from './importfrom.sol';

contract WARP{
  function enumImport(uint8 num1) pure public {
    selectEnum enum1;
  }
}
