pragma solidity ^0.8.11;

//SPDX-License-Identifier: MIT

contract WARP {
  uint8[] x;

  function get(uint256 offset) view public returns (uint8) {
    return x[offset];
  }

  function set(uint256 offset, uint8 value) public returns (uint8) {
    return x[offset] = value;
  }

  function pushNoArg() public returns (uint8) {
    return x.push();
  }

  function pushArg(uint8 v) public {
    return x.push(v);
  }

  function length() view public returns (uint256) {
    return x.length;
  }

  function pop() public {
    return x.pop();
  }

  string[] strs;
  function pushReturnDynArray() public returns (string memory, uint) {
    string storage s = strs.push();
    return (s, bytes(s).length);
  }
}
