// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

contract WARP {
  uint immutable uintValue;

  constructor(uint u) {
    uintValue = u;
  }

  function getUintValue() public view returns (uint) {
    return uintValue;
  }

	function addUintValue(uint x) public view returns (uint) {
		return uintValue + x;
	}
}
