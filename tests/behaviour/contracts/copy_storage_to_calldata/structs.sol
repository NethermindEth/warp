// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {
    struct S {
        uint8 x;
        uint y;
    }

    S s;

    function setS(S calldata a) public {
        s = a;
    }

    function getS() public view returns (S memory) {
        return s;
    }
}
