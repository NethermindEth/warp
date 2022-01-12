pragma solidity ^0.8.0;
contract WARP {
    function getBlockNumber() external returns (uint256) {
        return block.number;
    }

    function getBlockTimeStamp() external returns (uint256) {
        return block.timestamp;
    }
}