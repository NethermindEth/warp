pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {

    uint32 value = 0;

    function testInt8(int8 x) pure public returns (int8){
        return x;
    }
    
    function testInt8External(int8 x) pure external returns (int8){
        return x;
    }
    
    function testUint32(uint32 x) view public returns (uint32){
        x += value;
        return x;   
    }

    function testInt248(int248 x) pure public returns (int248){
        return x;
    }

    function testInt256(int256 x) pure public returns (int256){
        return x;
    }
    
    function testInt256Int8(int16 x, int8 y) pure public returns (int16){
        int16 returnValue = x + int16(y);
        return returnValue;
    }
}
