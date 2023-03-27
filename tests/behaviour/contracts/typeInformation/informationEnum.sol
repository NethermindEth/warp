// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
    enum Directions { Up, Down, Left, Right }

    function dMin () public pure returns (Directions) {
        return type(Directions).min;
    }

    function dMax () public pure returns (Directions) {
        return type(Directions).max;
    }
}
