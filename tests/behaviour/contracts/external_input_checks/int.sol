pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {

    // uint32 value = 0;
    struct S {
        int8 a;
        uint b;
        uint16 c;
    }

    function testInt8(S[] calldata x) pure external returns (int8){
        return x[0].a;
    }
     
    // function testUint32(uint32 x) view external returns (uint32){
    //     x += value;
    //     return x;   
    // }

    // function testInt248(int248 x) pure external returns (int248){
    //     return x;
    // }

    // function testInt256(int256 x) pure external returns (int256){
    //     return x;
    // }
    
    // function testInt256Int8(int16 x, int8 y) pure external returns (int16){
    //     int16 returnValue = x + int16(y);
    //     return returnValue;
    // }
}
