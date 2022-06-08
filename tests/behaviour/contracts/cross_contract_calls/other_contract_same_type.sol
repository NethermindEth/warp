pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  uint public counter;
	function getAndIncrementCounter() external returns (uint) { return counter++; }
	function getAndIncrementOtherCounter(address addr) external returns (uint) {
		WARP c = WARP(addr);
		return c.getAndIncrementCounter();
	}
  function getCounters(address addr) external view returns (uint, uint) {
    return (counter, WARP(addr).counter());
  }
}

contract WARPDuplicate {
  uint public counter;
	function getAndIncrementCounter() external returns (uint) { return counter++; }
	function getAndIncrementOtherCounter(address addr) external returns (uint) {
		WARP c = WARP(addr);
		return c.getAndIncrementCounter();
	}
  function getCounters(address addr) external view returns (uint, uint) {
    return (counter, WARP(addr).counter());
  }
}
