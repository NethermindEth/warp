pragma solidity ^0.8.6;

contract WARP {
    uint8  public decimals    = 18;
    uint256 public totalSupply= 100000000000000000000000000000000000;

    mapping (uint => uint)                       public  balanceOf;
    mapping (uint => mapping (uint => uint))  public  allowance;

    function deposit(uint sender, uint256 value) public payable returns (bool){
        balanceOf[sender] += value;
        return true;
    }

    function withdraw(uint[] calldata wad, uint sender) public payable {
        require(balanceOf[sender] >= wad[0]);
        balanceOf[sender] -= wad[0];
    }

    function approve(uint guy, uint wad, uint sender) public payable returns (bool) {
        allowance[sender][guy] = wad;
        return true;
    }

    function transferFrom(uint src, uint dst, uint wad, uint sender)
        public payable
        returns (bool)
    {

        if (src != sender) {
            require(allowance[src][sender] >= wad);
            require(balanceOf[src] >= wad);
            allowance[src][sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        return true;
    }
}