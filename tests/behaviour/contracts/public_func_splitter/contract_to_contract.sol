pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8 a = 3;
  
  function test(uint8 a) pure public returns (uint8) {
    uint8 a = 15;
    return a;
  }

}

contract WarpCaller {
    
    function callTest(address addr) pure public returns(uint8) {
        WARP c = WARP(addr);
        return c.test(100);
    }
    
}
