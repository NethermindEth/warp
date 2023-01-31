pragma solidity ^0.8.10;
 
//SPDX-License-Identifier: MIT
 
contract WARP {
   uint public x;
 
   fallback(bytes calldata) external returns(bytes memory){
       x += 1;
   }
}
