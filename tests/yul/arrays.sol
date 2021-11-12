pragma solidity ^0.8.6;

contract WARP {
    uint[] balanceOf;

    function set(uint i, uint256 value) public {
        balanceOf[i] = value;
    }

    function get(uint i) public returns (uint) {
        return (balanceOf[i]);
    }
}
