pragma solidity ^0.8.6;

contract WARP {
    uint8  public decimals    = 18;
    uint256 public totalSupply= 100000000000000000000000000000000000;

    mapping (uint => uint)                       public  balanceOf;

    function deposit(uint sender, uint256 value) public payable returns (uint, uint){
        balanceOf[sender] += value;
        return (21,12);
    }

    function withdraw(uint wad, uint sender) public payable {
        require(balanceOf[sender] >= wad);
        balanceOf[sender] -= wad;
        (uint a, uint b) = deposit(sender, wad);
    }


    function transferFrom(uint src, uint dst, uint wad, uint sender)
        public payable
        returns (bool)
    {

        if (src != sender) {
            require(balanceOf[src] >= wad);
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        return true;
    }
}
