pragma solidity ^0.8.6;

//SPDX-License-Identifier: MIT

contract WARP {
   
    function dArrayExternal(uint8[] memory x) pure external returns (uint8) {
        return (x[0]);
    }

    function dArrayPublic(uint8[] memory x) pure public returns (uint8) {
        return x[0];
    } 

    function dArrayMultipleInputsExternal(uint8[] memory x, uint8 y, uint8[] memory z) pure external returns (uint8){
        return x[0] + z[1];
    }
    
    function dArrayMultipleInputsPublic(uint8[] memory x, uint8 y, uint8[] memory z) pure public returns (uint8){
        return x[0] + z[1];
    }
}
