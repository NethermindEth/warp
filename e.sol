// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;


contract WARP {

    function number() external view returns (uint256) {
        uint256 y = block.number;
        return y;
    }
 
    // Testnet returns 0 for get_block_timestamp so there is no test.
    function timestamp() external view returns (uint256) {
        uint256 y = block.timestamp;
        return y; 
    }
}
