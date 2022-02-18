// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract WARP {

    uint[4] public arr = [1, 2, 3, 4];

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function clearAt(uint index) public {
        delete arr[index];
    }

    function clear() public {
        return delete arr;
    }
}
