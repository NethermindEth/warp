pragma solidity ^0.8.6;

contract WARP {
  function f() public view {
    this.h();
    g();
  }

  function g() private pure returns (uint256) {
    return 1;
  }

  function h() external pure returns (uint256) {
    return g1();
  }

  function g1() internal pure returns (uint256) {
    return 2;
  }

  function a() internal view {
    f();
    g();
    g1();
    this.h();
  }

  function b() private view {
    a();
  }
}
