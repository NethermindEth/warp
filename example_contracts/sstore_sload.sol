pragma solidity ^0.8.6;

contract WARP {
  function test() public returns (uint256 res) {
    assembly {
      sstore(0, 5)
      res := sload(1)
    }
  }
}
