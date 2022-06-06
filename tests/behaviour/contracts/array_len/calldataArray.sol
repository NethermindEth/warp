pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {

    uint256 x;
    uint128[] y;

    function add1(uint256 len) private pure returns (uint256) {
        return len + 1;
    }

    function mul2(uint256 len) private pure returns (uint256) {
        return len * 2;
    }
    
    function returnArrLength(uint128[] calldata arr) public pure returns (uint256) {
        return arr.length;
    }

    function returnArrDoubleLength(uint128[] calldata arr) public pure returns (uint256) {
        uint256 a = arr.length * 2;
        return a;
    }

    function fnCallWithArrLength(uint128[] calldata arr) public pure returns (uint256) {
        return add1(arr.length);
    }

    function fnCallArrLengthNestedCalls(uint128[] calldata arr) public pure returns (uint256) {
        return add1(arr.length) + mul2(arr.length) + add1(mul2(arr.length) + mul2(arr.length));
    }

    function assignLengthToStorageUint(uint128[] calldata arr) public returns (uint256) {
        x = arr.length;
        return x;
    }

    function assignToStorageArr(uint128[] calldata arr) public returns (uint256) {
        y = arr;
        return y.length;
    }

    function staticArrayLength(uint128[3] calldata arr) public pure returns (uint256) {
        return arr.length;
    }
}