pragma solidity ^0.8.6;

contract WARP {
    function pureFunction(uint src, uint dst, uint wad, uint sender)
        public pure
        returns (uint) {
      uint res = src & dst;
      res = res | sender;
      uint res1 = src ^ dst;
      if (res < 4) {
        res = res1 & wad;
      } else {
        res = res1 ^ wad;
      }
      return res;
    }
}
