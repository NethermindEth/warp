pragma solidity ^0.8.6;

struct S {
  uint256 a;
}

contract WARP {
  struct T {
    uint256 b;
  }
  T public ttt;

  function pureFunction(
    uint256 src,
    uint256 dst,
    uint256 wad,
    uint256 sender
  ) public pure returns (uint256) {
    S memory d = S({a: 1});
    return d.a;
  }
}
