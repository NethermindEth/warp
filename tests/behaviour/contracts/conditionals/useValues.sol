pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
    function getValues() pure internal returns (uint8, uint16) {
        return (1,2);
    }
    function useValues(bool choice) pure external returns (uint16, uint16) {
        return choice ? (3,4) : getValues();
    }
}
