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
        (WARP, D.A, 2);
        (2, (WARP, D.A, 4));
    }
}
