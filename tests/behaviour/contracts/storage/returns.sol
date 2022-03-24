pragma solidity ^0.8.10;

//SPDX-License-Identifier: MIT

contract WARP {
    uint8 i = 3;
    function ints() public returns (uint8) {
        return i;
    }

    uint8[2] x;
    function arrays() public returns (uint8, uint8) {
        x = [1,2];
        getArray()[0] = 2;
        return (x[0], x[1]);
    }

    function getArray() internal returns (uint8[2] storage) {
        return x;
    }

    mapping(uint8 => uint8) y;
    function mappings() public returns (uint8, uint8) {
        y[0] = 5;
        y[1] = 4;
        getMapping()[0] = 2;
        return (y[0], y[1]);
    }

    function getMapping() internal returns (mapping(uint8 => uint8) storage) {
        return y;
    }

    struct S {
        uint8 s;
    }

    S z;
    function structs() public returns (uint8) {
        z = S(3);
        getStruct().s = 2;
        return (z.s);
    }

    function getStruct() internal returns (S storage) {
        return z;
    }

    function tuples() public returns (uint8, uint8, uint8, uint) {
        (uint8 a, uint8[2] storage b, mapping(uint8=>uint8) storage c, S storage d) = getAll();
        a = 5;
        b[0] = 20;
        c[100] = 200;
        d.s = 100;
        return (i, x[0], y[100], z.s);
    }

    function getAll() internal returns (uint8, uint8[2] storage, mapping(uint8 => uint8) storage, S storage) {
        return (i,x,y,z);
    }
}
