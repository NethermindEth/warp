pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

import './mathLib2.sol';

contract WARP{
    using Multiplication for uint8;
    using Division for uint8;

    function mulDiv(uint8 num1, uint8 num2) pure public returns (uint8, uint8, uint8) {
    uint8 product = Multiplication.multiply(num1, num2);
    (uint8 quotient, uint8 remainder) = Division.divide(num1, num2);
    return (product, quotient, remainder);
  }

}
