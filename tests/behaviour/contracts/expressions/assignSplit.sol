pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
  function plusEqual() pure public returns (uint) {
    uint a = 56;
    uint b = 5 + (a += 4);
    return a; // 60
  }
  function starEqual() pure public returns (uint) {
    uint a = 5;
    uint b = 5 + (a *= 4);
    return a; // 20
  }
  function equal() pure public returns (uint) {
    uint a = 5;
    uint b = 5 + 56 * (7 + (a = 4));
    return a; // 4
  }
  function plusEqualTotal(uint x) pure public returns (uint) {
    uint a = 56;
    uint b = x + (5 + (a += 4));
    return b; // 65 + x
  }
  function starEqualTotal(uint x) pure public returns (uint) {
    uint a = 5;
    uint b = x + (5 + (a *= 4));
    return b; // 25 + x
  }
  function equalTotal(uint x) pure public returns (uint) {
    uint a = 10;
    uint b = x + (5 + (a = 1));
    return b; // 6 + x
  }
}
