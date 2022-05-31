pragma solidity ^0.8.14;
// SPDX-License-Identifier: MIT

contract WARP {
    function set(uint24[3][4] memory x) public {
        x[2][2] = 1;
        x[3][2] = 7;
    }

    function passDataToInnerFunction() public returns (uint24[3][4] memory) {
        uint24[3][4] memory data;
        set(data);
        return data;
    }
}
