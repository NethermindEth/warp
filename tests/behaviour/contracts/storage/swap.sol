contract WARP {
    struct S {
        uint8 a;
        uint8 b;
    }
    S public struct1;
    S public struct2;

    function set(uint8 a, uint8 b, uint8 c, uint8 d) public {
        struct1.a = a;
        struct1.b = b;
        struct2.a = c;
        struct2.b = d;
    }

    function swap() public {
        (struct1, struct2) = (struct2, struct1);
    }
}
