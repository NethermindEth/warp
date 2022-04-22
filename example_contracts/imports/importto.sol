pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//Specific Imports for libraries, free functions and enums
 import {lib1, lib2, multiply, selectEnum, sampleStruct } from './importfrom.sol';

contract WARP{
    using lib1 for uint8;
    using lib2 for uint8;

    function checkImports(uint8 num1, uint8 num2) pure public returns (bool) {
    uint8 m = multiply(num1, num2);
    sampleStruct storage s;
    selectEnum en;
    uint8 add = lib1.libAdd(num1, num2);
    uint8 sub = lib2.libSubtract(num1, num2);
    return true;
  }

}
