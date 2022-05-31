pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    uint8[][] arr = [[1]];
    uint8[] b = [1,2];

    function test() public {
        uint8[3] memory c = [1,2,3];
        uint8[] memory f;
        /* arr.push([1,2,3]); */
        arr.push(b);
        arr.push(c);
        b = c;
    }
}
