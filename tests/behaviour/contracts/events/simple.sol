contract WARP{
    struct C {
        uint8[] m1;
        uint256[3] m2;
    }

    //Event Definitions
    event uintEvent(uint);
    event arrayEvent(uint[]);
    event nestedArrayEvent(uint[][]);
    event structEvent(C);

    function add(uint256 a, uint256 b) public {
        emit uintEvent(a+b);
    }

    function array() public {
        uint[] memory a = new uint[](3);
        a[0] = 2;
        a[1] = 3;
        a[2] = 5;
        emit arrayEvent(a);
    }

    function nestedArray() public {
        uint[][] memory a = new uint[][](2);
        a[0] = new uint[](3);
        a[0][0] = 2;
        a[0][1] = 3;
        a[0][2] = 5;
        a[1] = new uint[](2);
        a[1][0] = 7;
        a[1][1] = 11;
        emit nestedArrayEvent(a);
    }

    function structComplex() public {
        C memory c = C(new uint8[](3), [uint256(7), 11, 13]);
        c.m1[0] = 2;
        c.m1[1] = 3;
        c.m1[2] = 5;
        emit structEvent(c);
    }
}
