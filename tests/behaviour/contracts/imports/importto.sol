pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT
import {Addition, Subtraction, mul } from './importfrom.sol';


contract WARP{
    using Addition for uint8;
    using Subtraction for uint8;

    function addSub(uint8 num1, uint8 num2) public returns (uint8, uint8) {
    //S storage s;
    //uint m = mul(num1, num2);
    uint8 add = Addition.add(num1, num2);
    uint8 sub = Subtraction.subtract(num1, num2);
    return (add, sub);
  }

}
