pragma solidity ^0.8.6;

contract WARP {
    function test() public view returns (uint res) {
        assembly {
            res := returndatasize()
            // Prevents getting inlined
            if calldataload(0) { revert(0, 0) }
        }
    }
}
