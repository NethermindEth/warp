pragma solidity ^0.8.6;
// SPDX-License-Identifier: GPL-3.0

contract WARP {
    
    function default_returnInsert(uint8 a) pure public returns (uint8 ) {
        a++;
    }

    function condition_returnInsert(uint8 x) pure public returns (uint8) {
        if (x == 1) {
            return ++x;
        } else if (x == 2){
            x+2;
        } else {
            return x;
        }
    }

    function revert_returnInserter(uint a) pure public {
        if (a == 1) {
            return revert();
        } else {
            return revert();
        }
    }

    function conditions_no_returnInsert(uint8 a) pure public returns(uint8){
        if (a == 1) {
            return ++a;
        } else {
            return a;
        }
    }

    function returnInsert_with_require(uint8 x, uint8 y) pure public returns (uint8 z) {
        require((z = x + y) >= x);
    }

}
