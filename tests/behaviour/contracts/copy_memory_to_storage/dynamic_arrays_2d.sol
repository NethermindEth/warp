pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT
contract WARP {
    uint8[][] public arr8;
    // uint[][] public arr256;

    function setArr8() public {
        uint8[][] memory mem8 = new uint8[][](3);
        mem8[0] = new uint8[](1);
        mem8[1] = new uint8[](2);
        mem8[2] = new uint8[](3);

        mem8[0][0] = 1;
        mem8[1][1] = 2;
        mem8[2][2] = 3;


        arr8 = mem8;
    }

    function getArr8(uint i) public view returns (uint8[] memory) {
        return arr8[i];
    }
}
