pragma solidity ^0.8.6;

contract WARP {
  function callMeMaybe(uint8 arr) external pure returns (bool) {
    if (arr > 5) {
      return true;
    } 
    return false;
  }
}