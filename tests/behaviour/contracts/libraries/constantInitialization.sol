pragma solidity ^0.8.0;

library c {
  int24 internal constant XXX = 10000;
  int24 internal constant YYY = XXX + 1;

  function CALLXY() external pure returns (int24) {
    return XXX + YYY;
  }
}

contract WARP {
  int24 constant AAA = 1000;
  int24 constant BBB = -AAA;

  function f() external pure returns (int24) {
    return c.CALLXY();
  }
}
