// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;


contract WARP {
    /*
    The functions have been tested on the Goerli test net to check that they
    produce a none zero value.
    */


    function number() external view returns (bool) {
        uint256 y = block.number;
        return y > 0;
    }
 
    // Testnet returns 0 for get_block_timestamp, therefore we cannot test 
    // this function comppletely. This function placed here purely to test 
    // that the file compiles.
    
    function timestamp() external view returns (uint256) {
        uint256 y = block.timestamp;
        return y; 
    }
}
