// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.14;

// Learn more about Cairo Blocks here: 
// https://nethermindeth.github.io/warp/docs/solidity_equivalents/addresses

contract WARP {

    function test160(uint160 me) public view {
        address x = address(uint256(me));
    }

    function test256(uint256 me) public view {
        address x = address(me);
        uint256 y = uint256(x);
    }
}
