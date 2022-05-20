pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    uint[] public a;
    bytes public d;
    function dynMemArrayLen() public pure returns (uint256){
        uint[] memory b = new uint[](2);
        b[0] = 1;
        return b.length;
    }
    function dynStorageArrayLen() public view returns (uint256){
        return a.length;
    }
    function bytesMemLength() public pure returns (uint256) {
        bytes memory c;
        return c.length;
    }
    function bytesStorageLength() public view returns (uint256) {
        return d.length;
    }
}
