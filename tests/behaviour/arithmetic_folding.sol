pragma solidity ^0.8.6;

contract WARP {
    function f() public pure returns (uint) {
      uint t = 8 + 6;
      assembly {
        t := add("a", t)
      }
      return t;
    }
}
