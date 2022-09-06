// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP  {
    struct S {
        uint8 m1;
        uint256 m2;
    }

    struct C {
        uint8[] m1;
        uint256[3] m2;
    }

    function structSimple() public pure returns (bytes memory) {
        S memory s = S(2, 3);
        return abi.encode(s);
    }

    function structComplex() public pure returns (bytes memory) {
        C memory c = C(new uint8[](3), [uint256(7), 11, 13]);
        c.m1[0] = 2;
        c.m1[1] = 3;
        c.m1[2] = 5;

        return abi.encode(c);
    }
}
