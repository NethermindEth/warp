pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    function dynMemArrayLen() public pure returns (uint256){
        uint[] memory b = new uint[](45);
        b[0] = 1;
        return b.length;
    }
}
