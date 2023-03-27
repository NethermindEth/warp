pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    uint[] public a;

    function dynStorageArrayLen() public  returns (uint256){
        a.push(1);
        return a.length;
    }
}
