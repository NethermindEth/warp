// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Warp {
    function test() public pure returns (uint256) {
        uint256 b = addmod(10, 10, 2);
        return b;
    }

    function addmod(uint a, uint b, uint m) public pure returns (uint256) {
        return (a + b) % m;
    }
}
