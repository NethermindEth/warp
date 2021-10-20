pragma solidity ^0.8.6;

contract WARP {
    mapping (uint =>  uint)  public  allowance;

    function transferFrom(uint src, uint wad, uint sender)
        public payable
        returns (uint) {
      uint res = 0;
      if (src != sender) {
        allowance[src] -= wad;
          res = 1;
        } else {
          res = 2;
        }
      return res;
    }
}