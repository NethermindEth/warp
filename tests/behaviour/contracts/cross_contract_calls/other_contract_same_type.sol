pragma solidity ^0.8.10;

// SPDX-License-Identifier: MIT

contract WARP {
  uint256 public counter;

  function getAndIncrementCounter() external returns (uint256) {
    return counter++;
  }

  function getAndIncrementOtherCounter(address addr) external returns (uint256) {
    WARP c = WARP(addr);
    return c.getAndIncrementCounter();
  }

  function getCounters(address addr) external view returns (uint256, uint256) {
    return (counter, WARP(addr).counter());
  }
}

contract WARPDuplicate {
  uint256 public counter;

  function getAndIncrementCounter() external returns (uint256) {
    return counter++;
  }

  function getAndIncrementOtherCounter(address addr) external returns (uint256) {
    WARP c = WARP(addr);
    return c.getAndIncrementCounter();
  }

  function getCounters(address addr) external view returns (uint256, uint256) {
    return (counter, WARP(addr).counter());
  }
}
