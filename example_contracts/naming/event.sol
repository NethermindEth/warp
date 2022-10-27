pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

contract WARP {
  event __warp_Log0(address _from, uint256 _id);

  function log_0(uint256 _id) external {
    emit __warp_Log0(msg.sender, _id);
  }
}
