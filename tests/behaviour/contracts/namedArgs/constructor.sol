// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract WARP {

    struct A{
        uint256 a;
        uint256 c;
    }
    struct B{
        uint256 a;
        uint256 z;
        A b;
        uint8[3] data;
    }
    B data = B({a:1, data :[1,2,3], b: A({c:1, a:45}), z:2});

    function getData() view public returns (uint, uint, uint, uint, uint, uint, uint) {
        return (data.a, data.z, data.b.a, data.b.c, data.data[0], data.data[1], data.data[2]);
    }
}
