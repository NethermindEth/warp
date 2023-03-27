pragma solidity ^0.8.6;

contract WARP {
  uint256 public counter;

  function increment() public returns (uint256) {
    counter += 1;
    return counter;
  }
}
