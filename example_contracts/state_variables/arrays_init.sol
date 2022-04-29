pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
 State variables of ArrayTypes formed with elementary types with initial values
*/

contract WARP {

    int[] public h = [int(1), int(2), int(3)];
    int[][] public i = [[int(1), int(2), int(3)], [int(4), int(5), int(6)]];

    address[][10] public j = [
        [address(0x34), address(0x35), address(0x36)],
        [address(0x37), address(0x38), address(0x39)],
        [address(0x3a), address(0x3b), address(0x3c)]
    ];
    string[] public k = new string[](3);
    uint112[][][] public l;
    
    constructor(){
        l.push([[1, 2, 3]]);
    }
}




