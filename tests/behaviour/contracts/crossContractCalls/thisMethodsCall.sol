pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract A {
  int public c = 334;
  int public d = -34;

  A curr_contract = A(this);

  function add(int a, int b) pure public returns (int) {
    return a + b;
  }

  function returnThis() view public returns (A) {
    return this;
  }
  
  function return_curr_contract() view public returns (A) {
    return curr_contract;
  }

  function execute_add(int a, int b) view public returns (int) {
    return this.add(a, b) + this.c() + curr_contract.d() + returnThis().d() + return_curr_contract().c();
  }
}
