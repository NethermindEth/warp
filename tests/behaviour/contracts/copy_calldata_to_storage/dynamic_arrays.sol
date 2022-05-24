// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {
    struct S {
        uint8 x;
        uint8 y;
    }

    uint8[] x;
    uint[] y;
    S[] z;

    function setX(uint8[] calldata a) public {
        x = a;
    }

    function setY(uint[] calldata a) public {
        y = a;
    }

    // function t3(S[] calldata a) public {
        // z = a;
    // }

    function getX() public view returns (uint8) {
        return x[0] + x[1] + x[2];
    }

    function getY() public view returns (uint) {
        return y[0] + y[1] + y[2];
    }
}
