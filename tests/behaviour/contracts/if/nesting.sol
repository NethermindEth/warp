pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    function nestedIfs(bool choice1, bool choice2) pure public returns (uint8, uint8) {
        uint8 x = 10;
        uint8 y = 3;

        if (choice1) {
            if (choice2) {
                x = 3;
            } else {
                x = 2;
            }
            y = 1;
        } else {
            if (choice2) {
                x = 1;
            } else {
                x = 0;
            }
            y = 0;
        }

        return (x,y);
    }

    function uncheckedBlock(bool choice) pure public returns (uint8 a) {
        uint8 x = 2;
        unchecked {
            if (choice) {
                x = 1;
            } else {
                x = 0;
            }
            x -= 2;
        }

        return x;
    }

    function loops(bool choice) pure public returns (uint8 a) {
        uint8 i = 0;
        for (; i < 3; ++i) {
            if (choice) {
                while(i < 3) {
                    ++i;
                }
            } else {
                for (uint8 j = 0; j < 2; ++j) {
                    ++i;
                }
            }
        }
        return i - 3;
    }
}
