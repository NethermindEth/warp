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

    uint8 c;


    function assignment() public {
        uint a;
        (a, ) = (3, s[7][]);
    }

    function varDeclStatement() public {  
        (uint a, uint b, ) = (3, 4, s[7][]);
    }

    function tupleExpression() public {
        (WARP, D.A, s[7][], 2);
    }
}
