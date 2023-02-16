pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

/*
 State variables of ArrayTypes formed with elementary types
*/

contract WARP {
    struct A{
        uint256 a;
        uint256 b;
    }

    struct B{
        uint256 a;
        address b;
        int120 c;
        A d;
    }

    A[] public a;
    
    A private b;

    A[] public c;

    B[] public d;

    constructor() {
        a.push(A({a: 1, b: 2}));
        b = A({a: 3, b: 4});
        c.push(A({a: 5, b: 6}));
        d.push(B({a: 7, b: address(0x1234567890123456789012345678901234567890), c: 9, d: A({b: 10, a: 11})}));
    }
}
