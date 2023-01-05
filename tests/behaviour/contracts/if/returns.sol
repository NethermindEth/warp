pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    function ifNoElse(bool choice) pure public returns (uint8 a) {
        if (choice) {
            return 1;
        }

        return 2;
    }

    function ifWithElse(bool choice) pure public returns (uint8 a) {
        if (choice) {
            return 1;
        } else {
            return 2;
        }
    }

    function unreachableCode(bool choice) pure public returns (uint8 a) {
        if (choice) {
            return 1;
        } else {
            return 2;
        }
        return 3;
    }
}
