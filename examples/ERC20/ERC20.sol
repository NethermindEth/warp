pragma solidity ^0.8.6;

contract WARP {
    uint8  public decimals    = 18;
    uint256 public totalSupply= 100000000000000000000000000000000000;

    mapping (uint => uint)                       public  balanceOf;
    mapping (uint => mapping (uint => uint))  public  allowance;

    function deposit(uint sender, uint256 value) public payable returns (uint, uint){
        balanceOf[sender] += value;
        return (21,12);
    }

    function withdraw(uint wad, uint sender) public payable {
        require(balanceOf[sender] >= wad);
        balanceOf[sender] -= wad;
        (uint a, uint b) = deposit(sender, wad);
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

        for (uint i = 20; i > 10; i--) {
            if (i == 3) {
                break;
            }
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        return true;
    }
}