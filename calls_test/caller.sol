pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

interface ICalled {
  function callMeMaybe(uint arr) external pure returns (bool);
}

contract WARP {
  function callMe(address add) external pure returns (bool) {
    return ICalled(add).callMeMaybe(66);
  }

}
