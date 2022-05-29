contract WARP {
    uint[3] x;
    function setX(uint[3] calldata a) public {
        x = a;  
    }

    function getX() public returns (uint[3] memory) {
        return x;
    }
}
