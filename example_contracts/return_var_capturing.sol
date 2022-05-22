pragma solidity >=0.8.6;

contract WARP {
  function rando(uint256 a, uint256 b) public payable returns (uint256) {
    if (a > b) {
      return a + 21;
    } else {
      return b + 42;
    }
  }
}
