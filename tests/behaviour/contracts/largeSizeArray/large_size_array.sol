pragma solidity ^0.8.0;

contract WARP {
    uint8[100000000] public data;

    function getLength() public returns (uint256) {
        return data.length;
    }

    function setValue(uint8 index, uint8 value) public returns (uint8) {
        data[index] = value;
        return data[index];
    }
}
