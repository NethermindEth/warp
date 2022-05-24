pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    uint[] public a;
    bytes public b;
    string public s = "storage strings are cool";
    function dynMemArrayLen() public pure returns (uint256){
        uint[] memory a_ = new uint[](2);
        a_[0] = 1;
        return a_.length;
    }
    function dynStorageArrayLen() public view returns (uint256){
        return a.length;
    }
    function bytesMemLength() public pure returns (uint256) {
        bytes memory b_;
        return b_.length;
    }
    function bytesStorageLength() public view returns (uint256) {
        return b.length;
    }
    function stringMemLength() public pure {
        string memory s_ = "asdfasdf";
    }
}
