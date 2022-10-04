// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract WARP {
    function decodeAsInt24(bytes memory data) public pure returns (int24) {
       return abi.decode(data, (int24)); 
    }

    function decodeAsUint256(bytes memory data) public pure returns (uint256) {
       return abi.decode(data, (uint256)); 
    }

    function decodeAsAddress(bytes memory data) public pure returns (address) {
        return abi.decode(data, (address));
    }

    function decodeAsAddressAndUint256(bytes memory data) public pure returns (address, uint256) {
        return abi.decode(data, (address, uint256));
    }
}

