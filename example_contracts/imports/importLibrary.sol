pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for libraries, free functions and enums
 import {libA, libB } from './importfrom.sol';

contract WARP{
    using libA for uint8;
    using libB for uint8;

    function libraryImport(uint8 num1, uint8 num2) pure public returns (uint8) {
    return (libA.Add(num1, num2) + libB.Subtract(num1, num2));
  }

}
