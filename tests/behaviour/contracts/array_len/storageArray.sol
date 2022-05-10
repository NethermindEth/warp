pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    uint[] public a;

    function dynStorageArrayLen() public view returns (uint256){
        return a.length;
    }
}
