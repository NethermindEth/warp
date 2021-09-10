pragma solidity ^0.8.6;

contract WARP {
    mapping (uint => mapping (uint => uint))  public  allowance;

    function transferFrom(uint src, uint dst, uint wad, uint sender)
        public payable
        returns (uint)
    {
      uint res = 0;
        if (src != sender) {
            allowance[src][sender] -= wad;
            res = 1;
        } else {
            res = 2;
        }

        return res;
    }
}
