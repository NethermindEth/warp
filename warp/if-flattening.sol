pragma solidity ^0.8.6;

contract WARP {
    mapping (uint => mapping (uint => uint))  public  allowance;

    function transferFrom(uint src, uint dst, uint wad, uint sender)
        public payable
        returns (bool)
    {
        if (src != sender) {
            allowance[src][sender] -= wad;
        }

        return true;
    }
}
