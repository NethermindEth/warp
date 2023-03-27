library D {
    enum A{a}
    struct B{
        A a;
    }
}

contract WARP {
    struct s {
        uint256 a;
        uint256 b;
    }

    function simple() public pure {
        uint;
    }

    function indexAccess() public pure {
        s[7][];

    }
    

    function memberAccess() public pure {
        D.A;
        D.B;
    }


    function identifier() public pure {
        WARP;
        D;
    }
}