// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

contract WARP {
  uint immutable uintValue;
  int16 immutable intValue;

  constructor(uint u, int16 i) {
    uintValue = u;
    intValue = i;
  }

  function getUintValue() public view returns (uint) {
    return uintValue;
  }

  function getIntValue() public view returns (int16) {
    return intValue;
  }

	function addUintValue(uint x) public view returns (uint) {
		return uintValue + x;
	}

  function addIntValue(int16 a) public view returns (int16) {
		return intValue + a;
	}
}
