pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    uint[] x;
    uint[5] y;
    function tryX1(uint8[] memory m) public returns (uint[] memory) {
        x = m;
        return x;
    }

    function tryX2(uint8[3] memory m) public returns (uint[] memory) {
        x = m;
        return x;
    }

    function tryY1(uint8[5] memory m) public returns (uint[5] memory) {
        y = m;
        return y;
    }

    function tryY2(uint8[3] memory m) public returns (uint[5] memory) {
        y = m;
        return y;
    }

    uint[][] xx;
    uint[][] xxt;
    uint[3][3] yy;
    uint[3][] xy;
    uint[][3] yx;

    function tryXX1() public returns (uint[] memory, uint[] memory, uint[] memory) {
        uint8[3][3] memory m = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
        xx = m;
        return (xx[0], xx[1], xx[2]);
    }

    function tryXX2() public returns (uint[] memory, uint[] memory) {
        uint8[][] memory m = new uint8[][](2);
        m[0] = new uint8[](2);
        m[0][0] = 1;
        m[0][1] = 2;
        m[1] = new uint8[](2);
        m[1][0] = 3;
        m[1][1] = 4;
        xx = m;
        return (xx[0], xx[1]);
    }
    function tryXX3() public returns (uint[] memory, uint[] memory, uint[] memory) {
        uint8[2][] memory m = new uint8[2][](3);
        m[0] = [1,2];
        m[1] = [3,4];
        m[2] = [5,6];

        xx = m;
        return (xx[0], xx[1], xx[2]);
    }


    function tryXX4() public returns (uint[] memory, uint[] memory, uint[] memory) {
        uint8[][3] memory m = [new uint8[](1), new uint8[](2), new uint8[](3)];
        m[0][0] = 1;
        m[1][1] = 2;
        m[2][2] = 3;

        xx = m;
        return (xx[0], xx[1], xx[2]);
    }

    /* 
    // Transpilation issues due to nesting issues
    function tryYY1() public returns (uint[3][3] memory) {
        uint8[2][2] memory m = [[1, 2], [3, 4]];
        yy = m;
        return yy;
    }

    //  Transpilation Issues when creating Uint256 struct array
    function tryXY1() public returns (uint[3][] memory) {
        uint8[2][] memory m = new uint8[2][](3);
        m[0] = [1,2];
        m[1] = [3,4];
        m[2] = [5,6];

        xy = m;
        return xy;
    }

    // Transpilation fails due to copy from memory to storage
    function tryYX1() public returns (uint[][3] memory) {
        uint8[][3] memory m = [new uint8[](1), new uint8[](2), new uint8[](3)];
        m[0][0] = 1;
        m[1][1] = 2;
        m[2][2] = 3;

        yx = m;
        return yx;
    }
    */
}
