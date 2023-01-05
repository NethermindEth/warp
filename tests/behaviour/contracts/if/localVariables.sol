pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    function ifNoElse(bool choice) pure public returns (uint8 a) {
        uint8 x = 2;

        if (choice) {
            x = 1;
        }

        return x;
    }

    function ifWithElse(bool choice) pure public returns (uint8 a) {
        uint8 x = 2;
        if (choice) {
            x = 1;
        } else {
            x= 3;
        }
        return x;
    }
}
