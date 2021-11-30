pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

import "./lib.sol";

interface IWarp {
  function callMeMaybe(uint8 arr) external pure returns (uint256);
}

interface IERC20 {
  function mint(address to, uint256 amount) external returns (bool);

  function balanceOf(address account) external view returns (uint256);

  function decimals() external pure returns (uint8);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);
}

contract WARP {
  function gimmeMoney(address add, address to) external returns (bool) {
    return IERC20(add).mint(to, 42) && Library.dummyFunc(true);
  }

  function checkMoneyz(address addr, address to) public view returns (uint256) {
    return IERC20(addr).balanceOf(to);
  }

  function sendMoneyz(
    address contract_addr,
    address from,
    address to,
    uint256 amount
  ) public returns (bool) {
    return IERC20(contract_addr).transferFrom(from, to, amount);
  }
}
