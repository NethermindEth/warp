pragma solidity ^0.8.0;

contract WARP {
    uint256[10000000000000000000] public data;

    function getLength() public view returns (uint256) {
        return data.length;
    }

    function setValue(uint256 index, uint256 value) public returns (uint256) {
        data[index] = value;
        return data[index];
    }
}
