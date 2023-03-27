pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

contract WARP {
    uint8[] public x;
    uint256[] public y;

    constructor() {
        // x = [1, 2, 3]; not working at the moment
        x.push(1);
        x.push(2);
        x.push(3);
        y.push(4);
        y.push(5);
        y.push(6);
    }

    function tryDeleteX() public returns (uint8) {
        delete x;
        x.push(11);
        x.push(17);
        return x[0] + x[1];
    }

    function tryDeleteY() public returns (uint256) {
        delete y;
        y.push();
        y.push(19);
        y.push(23);
        y.push(29);
        return y[0] + y[1] + y[2] + y[3];
    }
}

