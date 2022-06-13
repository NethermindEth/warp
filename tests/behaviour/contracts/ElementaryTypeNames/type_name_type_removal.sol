contract WARP {
    struct s {
        uint256 a;
        uint256 b;
    }

    uint8 c;

    function simple() public returns (int8) {
        uint;
        return 3; 
    }

    function indexAccess() public returns (int8) {
        s[7][];
        return 3;
    }
    
    function assignment() public returns (int8) {
        uint a;
        (a, ) = (3, s[7][]);
        return 3; 
    }

    function varDeclStatement() public returns (int8) {  
        (uint a, uint b, ) = (3, 4, s[7][]);
        return 3; 
    }
}
