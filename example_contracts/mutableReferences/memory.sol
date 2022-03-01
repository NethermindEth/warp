pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

//TODO test what happens when accessing arr3 before it is assigned

contract WARP {
  function memoryTest() public pure returns (uint){
    uint[] memory arr = new uint[](4);
    uint[] memory arr2 = new uint[](3);
    uint[] memory arr3;
    arr[1] = 2;
    arr3 = arr2;
    arr2[0] = 10;
    return arr3[0];
  }
}
