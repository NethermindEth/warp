// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

contract WARP {
  bytes2 a = 0x1234;
  bytes4 b = 0;
  bytes8 c = 0x0;
  bytes32 z = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
  bytes16 d;
  uint16 f = 2;

  constructor(bytes16 foo) {
    d = foo;
  }

	function getA() public view returns (bytes2) {
    return a;
  }

	function getB() public view returns (bytes4) {
		return b;
	}

	function getC() public view returns (bytes8) {
		return c;
	}

	function getD() public view returns (bytes16) {
    return d;
  }

  function shiftBytesBy(uint8 u) external view returns (bytes2) {
    return a << u;
  }

  function shiftBytesByConstant(bytes8 x) external view returns (bytes8) {
    return x >> f;
  }

	function bitwiseAnd(bytes2 k) public view returns (bytes2) {
		return a & k;
	}

	function bitwiseOr(bytes2 k) public view returns (bytes2) {
		return a | k;
	}

	function bitwiseXor(bytes2 k) public view returns (bytes2) {
		return a ^ k;
	}

	function bitwiseNor() public view returns (bytes2) {
		return ~a;
	}

	function _nestedBitwiseAnd(bytes2 j) internal view returns (bytes2) {
		return a & j;
	}

	function nestedBitwiseAnd(bytes2 k, bytes2 i) public view returns (bytes2) {
		bytes2 temp = _nestedBitwiseAnd(k);
		return i & temp;
	}
}
