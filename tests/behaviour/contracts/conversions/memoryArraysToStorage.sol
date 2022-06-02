pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    // ----- Simple uint -----
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

    //------ Simple int ------ 

    int16[] z;
    int32[5] w;

    function tryZ1() public returns (int16[] memory) {
        int8[] memory m = new int8[](3);
        m[0] = -1;
        m[1] = 5;
        m[2] = 10;
        z = m;

        return z;
    }

    function tryZ2() public returns (int32[5] memory) {
        int8[3] memory m = [-2, 4, 9];
        w = m;
        return w;
    }
    

    //------ Nested uint ------ 

    uint[][] xx;
    uint[][] xxt;
    uint[3][3] yy;
    uint[2][2][2] yyy;
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
        uint8[3][] memory m = new uint8[3][](3);
        m[0] = [1, 2, 3];
        m[1] = [4, 5, 6];
        m[2] = [7, 8, 9];

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

    function tryYY1() public returns (uint[3] memory, uint[3] memory, uint[3] memory) {
        uint8[2][3] memory m = [[1, 2], [3, 4], [5, 6]];
        yy = m;
        return (yy[0], yy[1], yy[2]);
    }

    function tryYY2() public returns (uint[3] memory, uint[3] memory, uint[3] memory) {
        uint8[2][2] memory m = [[1, 2], [3, 4]];
        yy = m;
        return (yy[0], yy[1], yy[2]);
    }

    function tryYYY() public returns (uint[2] memory, uint[2] memory, uint[2] memory) {
        uint8[1][1][1] memory m = [[[1]]];
        yyy = m;

        return (yyy[0][0], yyy[0][1], yyy[1][1]);
    }

    function tryXY1() public returns (uint[3][] memory) {
        uint8[2][] memory m = new uint8[2][](3);
        m[0] = [1,2];
        m[1] = [3,4];
        m[2] = [5,6];

        xy = m;
        return xy;
    }

    /*
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
