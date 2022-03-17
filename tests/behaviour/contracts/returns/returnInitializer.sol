pragma solidity ^0.8.6;
// SPDX-License-Identifier: GPL-3.0

contract WARP {

    function f0(uint a) pure public returns(uint b){
        return a;     
    }

    function f1(uint8 a) pure public returns(uint8 b, uint8 c){
        b=9;       
        c=a;
    }
}
