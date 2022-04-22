// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract WARP {
  byte a;
  byte b = 0xaa;
  uint16 f = 2;

  constructor(byte z) {
    a = z;
  }

	function getA() public view returns (byte) {
    return a;
  }

	function getB() public view returns (byte) {
    return b;
  }

  function shiftByteBy(uint8 u) external view returns (byte) {
    return a << u;
  }

  function shiftByteByConstant(byte x) external view returns (byte) {
    return x >> f;
  }

	function bitwiseAnd(byte k) public view returns (byte) {
		return a & k;
	}

	function bitwiseOr(byte k) public view returns (byte) {
		return a | k;
	}

	function bitwiseXor(byte k) public view returns (byte) {
		return a ^ k;
	}

	function bitwiseNor() public view returns (byte) {
		return ~a;
	}

	function _nestedBitwiseAnd(byte j) internal view returns (byte) {
		return a & j;
	}

	function nestedBitwiseAnd(byte k, byte i) public view returns (byte) {
		byte temp = _nestedBitwiseAnd(k);
		return i & temp;
	}
}
