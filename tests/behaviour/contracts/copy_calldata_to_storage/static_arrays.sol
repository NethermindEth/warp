contract WARP {
    uint[3] x;
    function setX(uint[3] calldata a) public {
        x = a;  
    }

    function getX() public returns (uint) {
        return x[0] + x[1] + x[2];
    }
}
