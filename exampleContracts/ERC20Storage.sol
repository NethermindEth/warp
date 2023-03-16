// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.14;

contract WARP {
  uint8 public decimals = 18;
  uint256 public totalSupply = 100000000000000000000000000000000000;

  mapping(uint256 => uint256) public balanceOf;

  function deposit(uint256 sender, uint256 value) public payable {
    balanceOf[sender] += value;
  }

  function withdraw(uint256 wad, uint256 sender) public payable {
    require(balanceOf[sender] >= wad);
    balanceOf[sender] -= wad;
  }

  function transferFrom(
    uint256 src,
    uint256 dst,
    uint256 wad,
    uint256 sender
  ) public payable returns (bool) {
    if (src != sender) {
      require(balanceOf[src] >= wad);
    }

    balanceOf[src] -= wad;
    balanceOf[dst] += wad;

    return true;
  }

  function get_balance(uint256 src) public returns (uint256) {
    return balanceOf[src];
  }
}
