pragma solidity ^0.8.10;
 
//SPDX-License-Identifier: MIT
 
import './structin.sol' ;
 
contract her is Store{
   
    function g(uint x) pure public returns(uint){
            Book memory b = Book (32,43,45);
      // uint x = 43;
     return b.author + x;
    }
 }
