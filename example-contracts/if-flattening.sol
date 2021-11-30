pragma solidity ^0.8.6;

contract WARP {
  mapping(uint256 => uint256) public allowance;

  function transferFrom(
    uint256 src,
    uint256 wad,
    uint256 sender
  ) public payable returns (uint256) {
    uint256 res = 0;
    if (src != sender) {
      allowance[src] -= wad;
      res = 1;
    } else {
      res = 2;
    }
    return res;
  }
}
