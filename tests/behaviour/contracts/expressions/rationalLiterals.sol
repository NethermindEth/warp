pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function equalValue() pure public returns (int8) {
    return (-1/3)*3;
  }

  function greaterThan() pure public returns (int8) {
    if(6/2 > 4/2)
        return 1;
    return 0; 
  }

  function add() pure public returns (int8) {
    return 12/3 + 20/5;
  }

  function subtract() pure public returns (int8) {
    return 25/5 - 10/5;
  }

  function multiply() pure public returns (int8) {
    return 30/6 * 10/2;
  }

  function divideBy() pure public returns (int8) {
    return (20/5) / (8/4);
  }

  function exp() pure public returns (uint8) {
    return (40/5) ** (4/2);
  }

  function mod() pure public returns (uint8) {
    return (40/2) % (12/2); 
  }

  function shiftLeft() pure public returns (uint8) {
    return (4/2 << 1);
  }

  function shiftRight() pure public returns (uint8) {
    return (4/2 >> 1);
  }

  function bitwiseNegate() pure public returns (int8) {
    return ~(4/2);
  }

  function toInteger() pure public returns (int8) {
    return 18/6;
  }

  function and() pure public returns (int8) {
    return 18&6;
  }

  function or() pure public returns (int8) {
    return 18|6;
  }

  function xor() pure public returns (int8) {
    return 18^6;
  }

  function not() pure public returns (int8) {
    return ~3;
  }
}