
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {
    uint8[] x;
    uint[] y;

    function pushToX(uint8 a) public {
        x.push(a);
    }

    function pushToY(uint a) public {
        y.push(a);
    }


    function getX() public view returns (uint8[] memory) {
        return x;
    }

    function getY() public view returns (uint[] memory) {
        return y;
    }
}
