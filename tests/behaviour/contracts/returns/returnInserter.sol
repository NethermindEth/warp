pragma solidity ^0.8.6;
// SPDX-License-Identifier: GPL-3.0

contract WARP {
    
    function test1(uint8 a) pure public returns (uint8 ) {
        a++;
    }

    function test2(uint8 x) pure public returns (uint8) {
        if (x == 1) {
            return ++x;
        } else if (x == 2){
            x+2;
        } else {
            return x;
        }
    }

    function test3(uint a) pure public {
        if (a == 1) {
            return revert();
        } else {
            return revert();
        }
    }

    function test4(uint a) pure public returns(uint){
        if (a == 1) {
            return a++;
        } else {
            return a;
        }
    }

    function test5(uint8 x, uint8 y) pure public returns (uint8 z) {
        require((z = x + y) >= x);
    }

    function test6(uint256 x, uint256 y) pure public returns (uint256 z) {
        require((z = x - y) <= x);
    }   

}