pragma solidity ^0.8.14;

contract WARP {
    function address2uint256Util(address _addr) public returns (uint256) {
        return uint256(_addr);
    }
    function address2uint256(address _addr) public returns (uint256) {
        return address2uint256Util(_addr);
    }
}