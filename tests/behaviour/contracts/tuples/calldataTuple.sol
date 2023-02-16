pragma solidity ^0.8.10;
//SPDX-License-Identifier: MIT

contract WARP {
 
  function createTuple(uint128[] calldata arr, uint128 num) private pure returns (uint128[] calldata, uint128) {
    return (arr, num);
  }

  function tupleSplit(uint128[] calldata arr, uint128 num) public pure returns (uint128) {
      (arr, num) = createTuple(arr, num);
      return num;
  }
}

