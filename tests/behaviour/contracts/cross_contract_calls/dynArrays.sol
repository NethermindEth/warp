pragma solidity ^0.8.14;

// SPDX-License-Identifier: MIT

contract ArrayProvider {
  function getArr() external returns (uint[] memory) {
    return new uint[](3);
  }
  function getMultiple(uint[] calldata inArr) pure external returns (uint[] calldata, uint[] memory, uint) {
    return (inArr, new uint[](5), 4);
  }
}

contract WARP {

  function receiveArr(ArrayProvider target) public returns (uint) {
    uint[] memory arr = target.getArr();
    return arr.length;
  }

  function receiveMultiple(uint[] calldata inArr, ArrayProvider target) public returns (uint,uint,uint,uint,uint,uint) {
    (uint[] memory a, uint[] memory b, uint c) = target.getMultiple(inArr);
    uint[] memory d;
    uint[] memory e;
    uint f;
    (d,e,f) = target.getMultiple(a);
    return (a.length, b.length, c, d.length, e.length, f);
  }
}
