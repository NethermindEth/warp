pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    struct A{
        uint256 a;
        uint256 b;
    }

    struct B{
        uint256 a;
        address b;
        int120 c;
        A d;
    }

    B public d;
}
