pragma solidity ^0.8.6;

contract WARP {
    function viewReturndatasize() public view returns (uint res) {
        assembly {
            res := returndatasize()
            // Prevents getting inlined
            if res { revert(0, 0) }
        }
    }
}
