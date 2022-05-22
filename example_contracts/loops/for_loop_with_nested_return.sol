pragma solidity >=0.8.6;

contract WARP {
  function transferFrom(uint256 i, uint256 j) public payable returns (bool) {
    for (uint256 k = 0; k < i; k += j) {
      if (k > j) {
        return false;
      }
      k -= 1;
    }
    return true;
  }
}
