// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {
    struct S {
        uint8 x;
        uint y;
    }

    S s;
    S[] f;

    function setS(S calldata a) public {
        s = a;
    }

    function getS() public view returns (uint) {
        uint x = uint(s.x);
        uint y = s.y;

        return x + y;
    }

    function setF() public {
        f.push(S(10, 20));
        f.push(S(2, 3));
        f.push(S(3, 4));
    }

    function getF() public view returns (S[] memory) {
        return f;
    }

    struct C {
        uint x;
        uint8 y;
        S z;
    }

    struct D {
        uint x;
        C z;
    }

    D d = D(1, C(1, 2, S(1, 2)));
    D[] e;

    function setE() public {
        e.push(D(1, C(1, 2, S(1, 2))));
        e.push(D(3, C(3, 2, S(3, 2))));
        e.push(D(5, C(5, 7, S(5, 7))));
    }

    function getD() public returns (D memory) {
        return d;
    }

    function getE() public returns (D[] memory) {
        return e;
    }

}
