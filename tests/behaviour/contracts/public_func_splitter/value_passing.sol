pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract A {
  uint8 a = 8;
  
  function f(uint8 a) pure public returns (uint8) {
    uint8 b = a;
    uint8 a = 25;
    return a;
  }

}

contract WARP {
  uint8 a = 3;
  
  function f(uint8 a) pure public returns (uint8) {
    uint8 b = a;
    uint8 a = 15;
    return a;
  }

  function internalCallIdentifier(uint8 a) pure public returns (uint8) {
   uint8 c = f(a);
   return c;
   }

 function internalCallMemberAccess(uint8 a) pure public returns (uint8) {
   uint8 c = WARP.f(a);
   return c;
   }

 function externalCallMemberAccess(uint8 a) view public returns (uint8) {
   uint8 c = this.f(a);
   return c;
   }

  function externalCrossContract(address addr) pure public returns (uint8) {
    A crossContract = A(addr);
    uint8 ret = crossContract.f(10);
    return ret;
  }
}
