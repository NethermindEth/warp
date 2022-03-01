pragma solidity ^0.8.6;

contract WARP {
  function payableFunction(
    uint256 src,
    uint256 dst,
    uint256 wad,
    uint256 sender
  ) public payable returns (uint256) {
    uint256 res = src & dst;
    res = res | sender;
    uint256 res1 = src ^ dst;
    if (res < 4) {
      res = res1 & wad;
    } else {
      res = res1 ^ wad;
    }
    return res;
  }
}
