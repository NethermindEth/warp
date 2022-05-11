// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WARP {
  uint256 public current_pos;
  uint256 public n = 1000;

  constructor(uint256 pos) {
    current_pos = pos;
  }

  function move_valid(uint256 pos, uint256 value) public returns (bool) {
    return pos > 0 && (pos < n || update_length(pos, value)) && move(pos);
  }

  function move(uint256 pos) internal returns (bool) {
    if (current_pos > pos) return false;
    current_pos = pos;
    return true;
  }

  function update_length(uint256 pos, uint256 value) internal returns (bool) {
    if ((pos - n) < value) {
      n += value;
      return true;
    }
    return false;
  }
}
